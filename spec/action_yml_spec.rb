# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

RSpec.describe 'action.yml' do
  let(:action) { YAML.load_file('action.yml') }
  let(:steps) { action.fetch('runs').fetch('steps') }
  let(:step_names) { steps.map { |step| step['name'] } }

  it 'uses rv clean-install for modern Ruby bundler-cache installs' do
    install_step = steps.fetch(step_names.index('Install gems with rv'))

    expect(install_step.fetch('if')).to include("inputs.bundler-cache == 'true'")
    expect(install_step.fetch('if')).to include("inputs.ore-install != 'true'")
    expect(install_step.fetch('run')).to include('~/.local/bin/rv ci --gemfile')
  end

  it 'retries dependency resolution and rv gem installation without changing sources' do
    install_step = steps.fetch(step_names.index('Install gems with rv'))
    script = install_step.fetch('run')

    expect(script).to include('gem-install-retries')
    expect(script).to include('bundle lock')
    expect(script).to include('Retrying in ${BACKOFF}s without changing Gemfile sources')
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
  end

  it 'writes a setup-ruby-flash summary for the ruby/setup-ruby compatibility path' do
    fallback_timer_step = steps.fetch(step_names.index('End ruby/setup-ruby compatibility timer'))
    script = fallback_timer_step.fetch('run')

    expect(script).to include('setup-ruby-flash Summary')
    expect(script).to include('Selected Path | ruby/setup-ruby compatibility path')
    expect(script).to include('Setup Time | ${ELAPSED}s')
  end
end
