require 'active_record'
require 'minitest/autorun'
require 'bourne'
require 'postgres_ext'
require 'database_cleaner'

require 'dotenv'
Dotenv.load

ActiveRecord::Base.establish_connection

class Person < ActiveRecord::Base
end

DatabaseCleaner.strategy = :deletion

class MiniTest::Spec
  class << self
    alias :context :describe
  end

  before do
    DatabaseCleaner.start
  end

  after do
    DatabaseCleaner.clean
  end
end

#RSpec.configure do |config|
  #config.before(:suite) do
    #DatabaseCleaner.clean
    #DatabaseCleaner.strategy = :deletion
  #end
  #config.before(:each) do
    #DatabaseCleaner.clean
  #end

  #config.treat_symbols_as_metadata_keys_with_true_values = true
  #config.mock_with :mocha
  #config.backtrace_clean_patterns = [
    ##/\/lib\d*\/ruby\//,
    ##/bin\//,
    ##/gems/,
    ##/spec\/spec_helper\.rb/,
    #/lib\/rspec\/(core|expectations|matchers|mocks)/
  #]
#end
