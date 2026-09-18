# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

RSpec.describe 'action.yml' do
  let(:action) { YAML.load_file('action.yml') }
  let(:steps) { action.fetch('runs').fetch('steps') }
  let(:step_names) { steps.map { |step| step['name'] } }
  let(:ruby_setup_cache_expression) { "${{ steps.setup-plan.outputs.ruby-setup-bundler-cache == 'true' }}" }
  let(:manual_compatibility_bundle_expression) { "steps.setup-plan.outputs.manual-compatibility-bundle == 'true'" }
  let(:retry_helper_source) { 'source "${GITHUB_ACTION_PATH//\\\\//}/scripts/retry.sh"' }

  it 'defines appraisal and trusted gem preinstall inputs' do
    inputs = action.fetch('inputs')

    expect(inputs.fetch('pre-bundle-gems').fetch('description')).to include('passed to `gem install`')
    expect(inputs.fetch('pre-appraisal-root-gemfile-gems').fetch('description')).to include('passed to `gem install`')
    expect(inputs.fetch('appraisal-root-gemfile').fetch('default')).to eq('Appraisal.root.gemfile')
    expect(inputs.fetch('appraisal-name').fetch('default')).to eq('')
    expect(inputs.fetch('appraisal-cache').fetch('default')).to eq('true')
    expect(inputs.fetch('appraisal-install-retries').fetch('default')).to eq('2')
    expect(inputs.fetch('main-bundle-install').fetch('default')).to eq('auto')
    expect(inputs.fetch('main-bundle-install').fetch('description')).to include('appraisal-only workflows')
    expect(inputs.fetch('manual-compatibility-bundle').fetch('default')).to eq('false')
    expect(inputs.fetch('manual-compatibility-bundle').fetch('description')).to include('retrying Bundler installer')
  end

  it 'uses rv clean-install for modern Ruby bundler-cache installs' do
    install_step = steps.fetch(step_names.index('Install gems with rv'))

    expect(install_step.fetch('if')).to eq("steps.setup-plan.outputs.fast-bundler-install == 'true'")
    expect(install_step.fetch('run')).to include('RV_CI_ARGS=(--gemfile "$GEMFILE")')
    expect(install_step.fetch('run')).to include('"$RV_BIN" ci "${RV_CI_ARGS[@]}"')
  end

  it 'retries dependency resolution and rv gem installation without changing sources' do
    install_step = steps.fetch(step_names.index('Install gems with rv'))
    script = install_step.fetch('run')

    expect(script).to include('gem-install-retries')
    expect(script).to include(retry_helper_source)
    expect(script).to include('setup_ruby_flash_retry "bundle lock" "$MAX_RETRIES" bundle lock --gemfile "$GEMFILE"')
    expect(script).to include('setup_ruby_flash_retry "rv clean-install" "$MAX_RETRIES" "$RV_BIN" ci')
    expect(script).not_to include('run_with_retries')
    expect(script).not_to include('rubygems.org')
    expect(script).not_to include('mirror.https://gem.coop')
  end

  it 'validates the gem installation retry count before running installs' do
    install_step = steps.fetch(step_names.index('Install gems with rv'))
    script = install_step.fetch('run')

    expect(script).to include('gem-install-retries must be a positive integer')
  end

  it 'exports an absolute Bundler path for subsequent workflow steps' do
    install_step = steps.fetch(step_names.index('Install gems with rv'))
    script = install_step.fetch('run')

    expect(script).to include('BUNDLE_PATH_VALUE="$PWD/vendor/bundle"')
    expect(script).to include('echo "BUNDLE_PATH=$BUNDLE_PATH_VALUE" >> "$GITHUB_ENV"')
  end

  it 'keeps ore opt-in instead of treating bundler-cache as an ore alias' do
    ore_step = steps.fetch(step_names.index('Determine if ore should be installed'))
    script = ore_step.fetch('run')

    expect(script).to include('if [ "$ORE_INSTALL" = "true" ]; then')
    expect(script).not_to include('|| [ "$BUNDLER_CACHE" = "true" ]')
  end

  it 'keeps unsupported Ruby versions on the ruby/setup-ruby compatibility path' do
    fallback_step = steps.fetch(step_names.index('Setup Ruby with ruby/setup-ruby (compatibility path)'))

    expect(fallback_step.fetch('uses')).to eq('ruby/setup-ruby@v1')
    expect(fallback_step.fetch('if')).to eq("steps.check-support.outputs.use-fallback == 'true'")
    expect(fallback_step.dig('with', 'bundler-cache')).to eq(ruby_setup_cache_expression)
  end

  it 'precomputes setup workflow decisions before installing gems' do
    plan_step = steps.fetch(step_names.index('Plan setup workflow'))
    script = plan_step.fetch('run')
    plan_index = step_names.index('Plan setup workflow')
    compatibility_index = step_names.index('Setup Ruby with ruby/setup-ruby (compatibility path)')

    expect(plan_index).to be < compatibility_index
    expect(script).to include('main-bundle-install must be one of: auto, true, false')
    expect(script).to include('manual-compatibility-bundle must be true or false')
    expect(script).to include('MANUAL_COMPATIBILITY_BUNDLE_INPUT="${{ inputs.manual-compatibility-bundle }}"')
    expect(script).to include('INSTALL_PRE_BUNDLE_GEMS="${{ inputs.pre-bundle-gems !=')
    expect(script).to include('FAST_BUNDLER_INSTALL="false"')
    expect(script).to include('MANUAL_COMPATIBILITY_BUNDLE="false"')
    expect(script).to include('RUBY_SETUP_BUNDLER_CACHE="false"')
    expect(script).to include('echo "fast-bundler-install=$FAST_BUNDLER_INSTALL"')
    expect(script).to include('echo "manual-compatibility-bundle=$MANUAL_COMPATIBILITY_BUNDLE"')
    expect(script).to include('echo "ruby-setup-bundler-cache=$RUBY_SETUP_BUNDLER_CACHE"')
  end

  it 'installs trusted pre-bundle gem arguments before bundle installation' do
    pre_bundle_step = steps.fetch(step_names.index('Install pre-bundle gems'))
    script = pre_bundle_step.fetch('run')

    expect(pre_bundle_step.fetch('if')).to eq("steps.setup-plan.outputs.install-pre-bundle-gems == 'true'")
    expect(script).to include('gem install $gem_args $DOC_FLAG')
    expect(script).to include('SETUP_RUBY_FLASH_PRE_BUNDLE_GEMS')
    expect(script).not_to include('eval')
  end

  it 'runs compatibility-path bundle installation itself when preinstall or appraisal inputs need ordering' do
    compatibility_bundle_step = steps.fetch(step_names.index('Install gems with Bundler (compatibility path)'))
    script = compatibility_bundle_step.fetch('run')

    expect(compatibility_bundle_step.fetch('if')).to eq(manual_compatibility_bundle_expression)
    expect(script).to include('gem-install-retries must be a positive integer')
    expect(script).to include(retry_helper_source)
    expect(script).to include('setup_ruby_flash_retry "bundle install for $GEMFILE" "$MAX_RETRIES" bundle install')
    expect(script).to include('bundle install --gemfile "$GEMFILE" --jobs 4')
  end

  it 'allows appraisal workflows to skip main Gemfile installation' do
    fast_cache_key_step = steps.fetch(step_names.index('Generate Bundler gem cache key'))
    fast_cache_step = steps.fetch(step_names.index('Cache Bundler gems'))
    fast_install_step = steps.fetch(step_names.index('Install gems with rv'))
    compatibility_bundle_step = steps.fetch(step_names.index('Install gems with Bundler (compatibility path)'))
    fallback_step = steps.fetch(step_names.index('Setup Ruby with ruby/setup-ruby (compatibility path)'))

    [
      fast_cache_key_step,
      fast_cache_step,
      fast_install_step
    ].each do |step|
      expect(step.fetch('if')).to eq("steps.setup-plan.outputs.fast-bundler-install == 'true'")
    end

    expect(compatibility_bundle_step.fetch('if')).to eq(manual_compatibility_bundle_expression)
    expect(fallback_step.dig('with', 'bundler-cache')).to eq(ruby_setup_cache_expression)
  end

  it 'resolves a versioned summary title from the action ref when available' do
    summary_title_step = steps.fetch(step_names.index('Resolve setup-ruby-flash summary title'))
    script = summary_title_step.fetch('run')

    expect(script).to include('ACTION_REF="${{ github.action_ref }}"')
    expect(script).to include('VERSION="${ACTION_REF#refs/tags/}"')
    expect(script).to include('git -C "$ACTION_PATH" describe --tags --always --dirty')
    expect(script).to include('LABEL="v$VERSION"')
    expect(script).to include('LABEL="@$VERSION"')
    expect(script).to include('TITLE="setup-ruby-flash Summary ${LABEL} ⚡"')
    expect(script).to include('TITLE="setup-ruby-flash Summary ⚡"')
    expect(script).to include('echo "title=$TITLE" >> "$GITHUB_OUTPUT"')
  end

  it 'writes a setup-ruby-flash summary for the ruby/setup-ruby compatibility path' do
    fallback_timer_step = steps.fetch(step_names.index('End ruby/setup-ruby compatibility timer'))
    script = fallback_timer_step.fetch('run')

    expect(script).to include('steps.summary-title.outputs.title')
    expect(script).to include("INSTALLED_RUBY_VERSION=$(ruby -e 'print RUBY_DESCRIPTION'")
    expect(script).to include('Installed Ruby Version | $INSTALLED_RUBY_VERSION')
    expect(script).to include('case "${{ steps.check-support.outputs.ruby-version }}" in')
    expect(script).to include('*head*)')
    expect(script).to include('RUBY_REVISION')
    expect(script).to include('JRUBY_REVISION')
    expect(script).to include('TruffleRuby::BUILD_REVISION')
    expect(script).to include('Ruby Build Revision | $RUBY_BUILD_REVISION')
    expect(script).to include('Selected Path | ruby/setup-ruby compatibility path')
    expect(script).to include('Setup Time | ${ELAPSED}s')
  end

  it 'prints the full rv Ruby version when it differs from the selected version' do
    summary_steps = [
      steps.fetch(step_names.index('Install gems with rv')),
      steps.fetch(step_names.index('Generate summary (Ruby only)')),
      steps.fetch(step_names.index('Install gems with ore'))
    ]

    summary_steps.each do |step|
      script = step.fetch('run')

      expect(script).to include('RUBY_VERSION_SUMMARY="${{ steps.detect-ruby.outputs.version }}"')
      expect(script).to include('FULL_RUBY_VERSION="${{ steps.setup.outputs.ruby-full-version }}"')
      expect(script).to include('RUBY_VERSION_SUMMARY="$RUBY_VERSION_SUMMARY ($FULL_RUBY_VERSION)"')
      expect(script).to include('Ruby Version | $RUBY_VERSION_SUMMARY')
      expect(script).to include('steps.summary-title.outputs.title')
    end
  end

  it 'installs the configured appraisal with isolated caching and retries' do
    cache_key_step = steps.fetch(step_names.index('Generate appraisal gem cache key'))
    cache_step = steps.fetch(step_names.index('Cache appraisal gems'))
    install_step = steps.fetch(step_names.index('Install appraisal'))
    script = install_step.fetch('run')

    expect(cache_key_step.fetch('if')).to eq("steps.setup-plan.outputs.cache-appraisal == 'true'")
    expect(cache_step.fetch('if')).to eq("steps.setup-plan.outputs.cache-appraisal == 'true'")
    expect(install_step.fetch('if')).to eq("steps.setup-plan.outputs.install-appraisal == 'true'")
    expect(cache_step.dig('with', 'path')).to eq('${{ inputs.working-directory }}/vendor/appraisal-bundle')
    expect(script).to include('ROOT_GEMFILE="${{ inputs.appraisal-root-gemfile }}"')
    expect(script).to include('APPRAISAL_NAME="${{ inputs.appraisal-name }}"')
    expect(script).to include('gem install $gem_args $DOC_FLAG')
    expect(script).to include('SETUP_RUBY_FLASH_PRE_APPRAISAL_ROOT_GEMS')
    expect(script).to include('appraisal-install-retries must be a positive integer')
    expect(script).to include('BUNDLE_PATH_VALUE="$PWD/vendor/appraisal-bundle"')
    expect(script).to include('export BUNDLE_PATH="$BUNDLE_PATH_VALUE"')
    expect(script).to include(retry_helper_source)
    expect(script).to include('setup_ruby_flash_retry "appraisal root bundle install" "$MAX_RETRIES" env')
    expect(script).to include('env BUNDLE_GEMFILE="$ROOT_GEMFILE" bundle install --jobs 4')
    expect(script).to include('setup_ruby_flash_retry "appraisal install" "$MAX_RETRIES" env')
    expect(script).to include('env BUNDLE_GEMFILE="$ROOT_GEMFILE" bundle exec appraisal "$APPRAISAL_NAME" install')
    expect(script).not_to include('run_with_retries')
    expect(script).not_to include('eval')
  end

  it 'supports Windows platforms for rv installation and environment configuration' do
    platform_step = steps.fetch(step_names.index('Validate platform'))
    platform_script = platform_step.fetch('run')
    expect(platform_script).to include('Windows) OS="windows" ;;')
    expect(platform_script).to include('x86_64|AMD64)')
    expect(platform_script).to include('aarch64|arm64|ARM64)')

    install_rv_step = steps.fetch(step_names.index('Install rv from release'))
    install_rv_script = install_rv_step.fetch('run')
    expect(install_rv_script).to include('windows-amd64) RV_PLATFORM="x86_64-pc-windows-msvc" ;;')
    expect(install_rv_script).to include('windows-arm64) RV_PLATFORM="aarch64-pc-windows-msvc" ;;')
    expect(install_rv_script).to include('DOWNLOAD_URL="https://github.com/spinel-coop/rv/releases/download/v${VERSION}/rv-${RV_PLATFORM}.zip"')
    expect(install_rv_script).to include('unzip -q -o "$TMP_ZIP" rv.exe rvw.exe -d ~/.local/bin')

    add_path_step = steps.fetch(step_names.index('Add rv to PATH'))
    expect(add_path_step.fetch('run')).to include('cygpath -w "$HOME/.local/bin"')

    cache_ruby_step = steps.fetch(step_names.index('Cache Ruby installation'))
    expect(cache_ruby_step.dig('with', 'path')).to include('~/AppData/Roaming/rv/rubies')

    ore_step = steps.fetch(step_names.index('Determine if ore should be installed'))
    ore_script = ore_step.fetch('run')
    expect(ore_script).to include('if [ "$RUNNER_OS" = "Windows" ]; then')
    expect(ore_script).to include('echo "install-ore=false" >> $GITHUB_OUTPUT')

    setup_step = steps.fetch(step_names.index('Configure Ruby environment with rv shell integration'))
    setup_script = setup_step.fetch('run')
    expect(setup_script).to include('cygpath -m "$ACTUAL_GEM_HOME"')
    expect(setup_script).to include('cygpath -w "$RUBY_BIN_DIR"')
  end
end
