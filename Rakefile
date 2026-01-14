# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

# Acceptance tests - run AFTER the action has installed Ruby
# These verify the action worked correctly
RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = 'spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:acceptance) do |task|
  task.pattern = 'spec/acceptance/*_spec.rb'
  task.rspec_opts = '--tag acceptance'
end

RuboCop::RakeTask.new(:lint)

desc 'Run all checks (lint + acceptance tests)'
task ci: %i[lint spec]

task default: :spec
