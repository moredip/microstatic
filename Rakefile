#!/usr/bin/env rake

require "bundler/gem_tasks"
require 'rspec/core/rake_task'

$LOAD_PATH.unshift File.expand_path("../lib",__FILE__)

namespace :spec do
  desc "run unit specs"
  RSpec::Core::RakeTask.new(:unit) do |task|
    task.pattern = "spec/unit/**/*_spec.rb"
  end

  desc "run integration specs (requires AWS creds)"
  RSpec::Core::RakeTask.new(:integration) do |task|
    task.pattern = "spec/integration/**/*_spec.rb"
  end

  require 'microstatic/rake'
  desc "do a test s3 deploy to a hard-coded test bucket"
  Microstatic::Rake.s3_deploy_task(:test_s3_deploy) do |task|
    task.bucket_name = '1.microstatic-test-bucket.thepete.net'
    task.source_dir = 'spec/integration/fixtures'
    task.exclude = %r|subdir|
  end

  desc "setup a new AWS site [here for manual testing purposes]"
  Microstatic::Rake.aws_site_setup_task do |task|
  end

end

task :default => 'spec:unit'
