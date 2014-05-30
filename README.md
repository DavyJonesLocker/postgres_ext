# PostgresExt

Adds missing native PostgreSQL data types to ActiveRecord and convenient querying extensions for ActiveRecord and Arel for Rails 4.x

[![Build Status](https://secure.travis-ci.org/dockyard/postgres_ext.png?branch=master)](http://travis-ci.org/dockyard/postgres_ext)
[![Code Climate](https://codeclimate.com/github/dockyard/postgres_ext.png)](https://codeclimate.com/github/dockyard/postgres_ext)
[![Gem Version](https://badge.fury.io/rb/postgres_ext.png)](http://badge.fury.io/rb/postgres_ext)

## Looking for help? ##

If it is a bug [please open an issue on
Github](https://github.com/dockyard/postgres_ext/issues). If you need help using
the gem please ask the question on
[Stack Overflow](http://stackoverflow.com). Be sure to tag the
question with `DockYard` so we can find it.

## Installation

Add this line to your application's Gemfile:

    gem 'postgres_ext'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install postgres_ext

## Usage

Just `require 'postgres_ext'` and use ActiveRecord as you normally would! postgres\_ext extends
ActiveRecord's data type handling and query methods in both Arel and
ActiveRecord.

 * [Querying PostgreSQL datatypes](docs/querying.md)

Where are the datatypes from PostgresExt 1.x? ActiveRecord 4.x includes
all the data types that PostgresExt added to ActiveRecord 3.2.x. We'll
be adding more datatypes as we come across them.

## Developing

To work on postgres\_ext locally, follow these steps:

 1. Run `bundle install`, this will install (almost) all the development
    dependencies
 2. `gem install byebug` (not a declared dependency to not break CI)
 3. Run `rake setup`, this will set up the `.env` file necessary to run
    the tests and set up the database
 4. Run `rake db:create`, this will create the test database
 5. Run `rake db:migrate`, this will set up the database tables required
    by the test

## Authors

Dan McClain [twitter](http://twitter.com/_danmcclain) [github](http://github.com/danmcclain)

