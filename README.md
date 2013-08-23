# PostgresExt

Adds missing native PostgreSQL data types to ActiveRecord and convenient querying extensions for ActiveRecord and Arel for Rails 4.x

[![Build Status](https://secure.travis-ci.org/dockyard/postgres_ext.png?branch=master)](http://travis-ci.org/dockyard/postgres_ext)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/dockyard/postgres_ext)

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

## Authors

Dan McClain [twitter](http://twitter.com/_danmcclain) [github](http://github.com/danmcclain)

