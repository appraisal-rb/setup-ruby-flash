# frozen_string_literal: true

require 'spec_helper'
require 'English'

# These tests verify that ore was installed and gems are available.
# Only runs when ore-install was enabled in the action.
RSpec.describe 'ore Installation', :acceptance do
  before do
    skip 'ore not installed (ore-install: false)' unless system('which ore > /dev/null 2>&1')
  end

  describe 'ore binary' do
    it 'is available in PATH' do
      expect(system('which ore > /dev/null 2>&1')).to be true
    end

    it 'runs successfully' do
      expect(system('ore version > /dev/null 2>&1')).to be true
    end
  end

  describe 'gem installation' do
    it 'can list installed gems' do
      output = `ore list 2>&1`
      expect($CHILD_STATUS.success?).to be true
      expect(output).not_to be_empty
    end

    it 'installed gems from Gemfile' do
      skip 'No Gemfile present' unless File.exist?('Gemfile')

      # ore check verifies all gems are installed
      expect(system('ore check > /dev/null 2>&1')).to be true
    end
  end

  describe 'ore exec' do
    it 'can execute commands' do
      result = `ore exec -- ruby -e "puts 'hello'" 2>&1`.strip
      expect(result).to include('hello')
    end
  end
end
