#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'postgres_ext'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

require 'rvm-tester'
RVM::Tester::TesterTask.new(:suite) do |t|
  t.bundle_install = true                # updates Gemfile.lock, default is true
  t.use_travis = true                    # looks for Rubies in .travis.yml (on by default)
  t.command = "bundle exec rake spec"    # runs plain "rake" by default
  t.env = {"VERBOSE" => "1"}             # set any ENV vars
  t.verbose = true                       # shows more output, off by default
end

task :default => :spec
