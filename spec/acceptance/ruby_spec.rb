# frozen_string_literal: true

require 'spec_helper'

# These tests verify that the setup-ruby-flash GitHub Action worked correctly.
# They run AFTER the action has installed Ruby, rv, and ore.
# If Ruby isn't installed, these tests can't even run!
RSpec.describe 'Ruby Installation', :acceptance do
  describe 'ruby binary' do
    it 'is available in PATH' do
      expect(system('which ruby > /dev/null 2>&1')).to be true
    end

    it 'runs successfully' do
      expect(system('ruby --version > /dev/null 2>&1')).to be true
    end

    it 'is the expected version' do
      # Skip if EXPECTED_RUBY_VERSION not set (local development)
      skip 'EXPECTED_RUBY_VERSION not set' unless ENV['EXPECTED_RUBY_VERSION']

      actual_version = `ruby -e "puts RUBY_VERSION"`.strip
      expected = ENV.fetch('EXPECTED_RUBY_VERSION', nil)

      # Allow partial match (e.g., "3.4" matches "3.4.1")
      expect(actual_version).to start_with(expected)
    end
  end

  describe 'gem binary' do
    it 'is available in PATH' do
      expect(system('which gem > /dev/null 2>&1')).to be true
    end

    it 'runs successfully' do
      expect(system('gem --version > /dev/null 2>&1')).to be true
    end
  end

  describe 'bundler' do
    it 'is available' do
      expect(system('which bundle > /dev/null 2>&1')).to be true
    end
  end
end
