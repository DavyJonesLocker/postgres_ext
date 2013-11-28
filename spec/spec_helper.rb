require 'active_record'
require 'rspec/autorun'
require 'bourne'

require 'dotenv'
Dotenv.load

ActiveRecord::Base.establish_connection

class Person < ActiveRecord::Base
end


require 'postgres_ext'
require 'database_cleaner'

RSpec.configure do |config|
  config.before(:suite) { ActiveRecord::Base.connection.enable_extension('pg_trgm') }
  config.before(:suite) do
    DatabaseCleaner.clean
    DatabaseCleaner.strategy = :deletion
  end
  config.before(:each) do
    DatabaseCleaner.clean
  end

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.mock_with :mocha
  config.backtrace_clean_patterns = [
    #/\/lib\d*\/ruby\//,
    #/bin\//,
    #/gems/,
    #/spec\/spec_helper\.rb/,
    /lib\/rspec\/(core|expectations|matchers|mocks)/
  ]
end
