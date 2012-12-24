# Configure Rails Envinronment
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'rspec/rails'
require 'rspec/autorun'
require 'bourne'
require 'debugger' unless ENV['CI'] || (RUBY_PLATFORM =~ /java/)

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(ENGINE_RAILS_ROOT, 'spec/support/**/*.rb')].each { |f| require f }
require 'postgres_ext'

RSpec.configure do |config|
  config.before(:suite) { ActiveRecord::Base.connection.add_extension('pg_trgm') if ActiveRecord::Base.connection.supports_extensions?}
  config.use_transactional_fixtures = false
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
