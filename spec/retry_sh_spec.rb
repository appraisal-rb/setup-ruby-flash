# frozen_string_literal: true

require 'spec_helper'
require 'open3'
require 'tmpdir'

RSpec.describe 'scripts/retry.sh' do
  let(:script) { File.expand_path('../scripts/retry.sh', __dir__) }
  let(:github_bash_options) { %w[-e -o pipefail] }

  # Runs setup_ruby_flash_retry around ./fake-install in bash. GitHub Actions runs
  # `shell: bash` steps with `-e -o pipefail`.
  def run_retry(fake_install_body, max_attempts:, shell_options: github_bash_options)
    Dir.mktmpdir do |dir|
      File.write(File.join(dir, 'fake-install'), "#!/usr/bin/env bash\necho attempt >> attempts\n#{fake_install_body}")
      File.chmod(0o755, File.join(dir, 'fake-install'))
      output, status = Open3.capture2e(retry_env, 'bash', '--noprofile', '--norc', *shell_options, '-c',
                                       retry_command(dir, max_attempts))
      [output, status, File.read(File.join(dir, 'attempts')).lines.size]
    end
  end

  def retry_env
    { 'SETUP_RUBY_FLASH_RETRY_BACKOFF' => '0' }
  end

  def retry_command(dir, max_attempts)
    <<~BASH
      source #{script.inspect}
      cd #{dir.inspect}
      setup_ruby_flash_retry "bundle install" #{max_attempts} ./fake-install
      echo "unreachable after failure under errexit"
    BASH
  end

  def classify(line)
    Dir.mktmpdir do |dir|
      log = File.join(dir, 'log')
      File.write(log, "#{line}\n")
      command = "source #{script.inspect}; setup_ruby_flash_deterministic_failure #{log.inspect}"
      output, status = Open3.capture2e('bash', '-c', command)
      status.success? ? output.strip : nil
    end
  end

  it 'retries a transient failure until the command succeeds' do
    output, status, attempts = run_retry(<<~BASH, max_attempts: 4)
      if [ "$(wc -l < attempts)" -lt 3 ]; then
        echo "Gem::RemoteFetcher::FetchError: Net::OpenTimeout"
        exit 17
      fi
      echo "Bundle complete!"
    BASH

    expect(status).to be_success
    expect(attempts).to eq(3)
    expect(output).to include('bundle install attempt 3 of 4...', 'Bundle complete!')
    expect(output).to include('Retrying in 0s without changing Gemfile sources')
  end

  it 'stops after one attempt on a native extension build failure and keeps its exit status' do
    output, status, attempts = run_retry(<<~BASH, max_attempts: 7)
      echo "Gem::Ext::BuildError: ERROR: Failed to build gem native extension."
      echo "An error occurred while installing commonmarker (2.10.0), and Bundler cannot continue."
      exit 5
    BASH

    expect(status.exitstatus).to eq(5)
    expect(attempts).to eq(1)
    expect(output).to include('failed with a deterministic error (native extension build failure); not retrying')
    expect(output).not_to include('attempt 2 of 7', 'unreachable after failure under errexit')
  end

  it 'keeps retrying a gem that is missing from the index' do
    output, status, attempts = run_retry(<<~BASH, max_attempts: 3)
      echo "Could not find gem 'kettle-rb (>= 0.1.14)' in rubygems repository https://gem.coop/."
      exit 7
    BASH

    expect(status.exitstatus).to eq(7)
    expect(attempts).to eq(3)
    expect(output).to include('bundle install failed after 3 attempts')
  end

  it 'classifies failures the same way without pipefail' do
    output, status, attempts = run_retry(<<~BASH, max_attempts: 3, shell_options: %w[-e])
      echo 'Bundler could not find compatible versions for gem "activerecord"'
      exit 6
    BASH

    expect(status.exitstatus).to eq(6)
    expect(attempts).to eq(1)
    expect(output).to include('(dependency resolution conflict)')
  end

  it 'recognizes each deterministic failure category' do
    expect(classify('Gem::Ext::BuildError: ERROR')).to eq('native extension build failure')
    expect(classify('version solving has failed.')).to eq('dependency resolution conflict')
    expect(classify('nokogiri-1.18.0 requires ruby version >= 3.2')).to eq('incompatible Ruby version')
    expect(classify('[!] There was an error parsing `Gemfile`: syntax error')).to eq('Gemfile or gemspec error')
    expect(classify('Your bundle only supports platforms ["x86_64-linux"]')).to eq('lockfile or platform mismatch')
    expect(classify('git@github.com: Permission denied (publickey).')).to eq('git authentication failure')
    expect(classify('Net::ReadTimeout with #<TCPSocket:(closed)>')).to be_nil
  end
end
