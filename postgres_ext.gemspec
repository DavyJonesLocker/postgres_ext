# -*- encoding: utf-8 -*-
require File.expand_path('../lib/postgres_ext/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dan Seaver"]
  gem.email         = ["git@danseaver.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "postgres_ext"
  gem.require_paths = ["lib"]
  gem.version       = PostgresExt::VERSION

  gem.add_dependency 'activerecord', '~> 3.2.0'

  gem.add_development_dependency 'rails', '~> 3.2.0'
  gem.add_development_dependency 'rspec-rails', '~> 2.9.0'
  gem.add_development_dependency 'capybara', '~> 1.1.2'
  gem.add_development_dependency 'bourne', '~> 1.1.2'
  gem.add_development_dependency 'factory_girl_rails', '~> 3.2.0'
  gem.add_development_dependency 'pg', '~> 0.13.2'
  gem.add_development_dependency 'debugger', '~> 1.1.2'
  gem.add_development_dependency 'fivemat'
end
