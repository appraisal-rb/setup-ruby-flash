# frozen_string_literal: true

require 'spec_helper'
require 'English'

# These tests verify that rv was installed correctly by the action.
RSpec.describe 'rv Installation', :acceptance do
  describe 'rv binary' do
    it 'is available in PATH' do
      expect(system('which rv > /dev/null 2>&1')).to be true
    end

    it 'runs successfully' do
      expect(system('rv --version > /dev/null 2>&1')).to be true
    end

    it 'can list installed rubies' do
      output = `rv ruby list 2>&1`
      expect($CHILD_STATUS.success?).to be true
      expect(output).not_to be_empty
    end
  end
end
