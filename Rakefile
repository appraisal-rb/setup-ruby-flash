# frozen_string_literal: true

# Define a base default task early so other files can enhance it.
desc "Default tasks aggregator"
task :default do
  puts "Default task complete."
end

# External gems that define tasks - add here!
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require "kettle/dev"

# Acceptance tests - run AFTER the action has installed Ruby
# These verify the action worked correctly
RSpec::Core::RakeTask.new(:acceptance) do |task|
  task.pattern = 'spec/acceptance/*_spec.rb'
  task.rspec_opts = '--tag acceptance'
end

RuboCop::RakeTask.new(:lint)

desc 'Run all checks (lint + acceptance tests)'
task ci: %i[lint spec]
