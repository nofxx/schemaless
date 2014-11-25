#!/usr/bin/env rake
require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
# load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

# Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each {|f| load f }


# RSpec::Core::RakeTask.new(:spec => 'app:db:test:prepare')
RSpec::Core::RakeTask.new
RuboCop::RakeTask.new

task default: [:spec, :rubocop]
