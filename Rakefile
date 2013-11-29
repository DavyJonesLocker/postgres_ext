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

Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task :default => :test

task :setup do
  if File.exist?('.env')
    puts 'This will overwrite your existing .env file'
  end
  print 'Enter your database name: [postgres_ext_test] '
  db_name = STDIN.gets.chomp
  print 'Enter your database user: [] '
  db_user = STDIN.gets.chomp
  print 'Enter your database password: [] '
  db_password = STDIN.gets.chomp
  print 'Enter your database server: [localhost] '
  db_server = STDIN.gets.chomp

  db_name = 'postgres_ext_test' if db_name.empty?
  db_password = ":#{db_password}" unless db_password.empty?
  db_server = 'localhost' if db_server.empty?

  db_server = "@#{db_server}" unless db_user.empty?

  env_path = File.expand_path('./.env')
  File.open(env_path, 'w') do |file|
    file.puts "DATABASE_NAME=#{db_name}"
    file.puts "DATABASE_URL=\"postgres://#{db_user}#{db_password}#{db_server}/#{db_name}\""
  end

  puts '.env file saved'
end

namespace :db do
  task :load_db_settings do
    require 'active_record'
    unless ENV['DATABASE_URL']
      require 'dotenv'
      Dotenv.load
    end
  end

  task :drop => :load_db_settings do
    %x{ dropdb #{ENV['DATABASE_NAME']} }
  end

  task :create => :load_db_settings do
    %x{ createdb #{ENV['DATABASE_NAME']} }
  end

  task :migrate => :load_db_settings do
    ActiveRecord::Base.establish_connection

    ActiveRecord::Base.connection.create_table :people, force: true do |t|
      t.inet     "ip"
      t.cidr     "subnet"
      t.integer  "tag_ids",      array: true
      t.string   "tags",         array: true
      t.text     "biography"
      t.integer  "lucky_number"
      t.numrange "num_range"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    puts 'Database migrated'
  end
end
