source 'https://rubygems.org'

# Specify your gem's dependencies in postgres_ext.gemspec
gemspec
unless ENV['CI']
  if RUBY_PLATFORM =~ /java/
    gem 'ruby-debug'
  else
    gem 'byebug'
  end
end
gem 'fivemat'
