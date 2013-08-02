source 'https://rubygems.org'

# Specify your gem's dependencies in postgres_ext.gemspec
gemspec
unless ENV['CI']
  if RUBY_PLATFORM =~ /java/
    gem 'ruby-debug'
  elsif RUBY_VERSION == '2.0.0'
    gem 'byebug'
  end
end
gem 'fivemat'

group :test, :development do
  gem 'debugger'
end
