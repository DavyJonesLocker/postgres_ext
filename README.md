# PostgresExt

Adds support for missing PostgreSQL data types to ActiveRecord.

## Current Status: [![Build Status](https://secure.travis-ci.org/dockyard/postgres_ext.png?branch=master)](http://travis-ci.org/dockyard/postgres_ext)

## Roadmap

 * Arel support for INET, CIDR and Array related where clauses
 * Backport HStore code from Rails 4.0

## Installation

Add this line to your application's Gemfile:

    gem 'postgres_ext'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install postgres_ext

## Usage

Just `require 'postgres_ext'` and use ActiveRecord as you normally would! postgres_ext extends
ActiveRecord's data type handling.

 * [Migration/Schema.rb support](#migrationschemarb-support)
 * [Type Casting support](#type-casting-support)

### Usage Notes
Take care when dealing with arrays and other types that allow you to
update their value in place. In place changes are not currently tracked
in Rails (see [this issue](https://github.com/rails/rails/issues/6954)).
To track changes that happen via `#<<` or other instance methods, be
sure to call `<attribute>_will_change!` so that Active Record nows to
persist the change.

## Migration/Schema.rb support

### INET

```ruby
create_table :testing do |t|
  t.inet :inet_column
  # or
  t.inet :inet_column_1, :inet_column_2
  # or
  t.column :inet_column, :inet
end
```

### CIDR

```ruby
create_table :testing do |t|
  t.cidr :cidr_column
  # or
  t.cidr :cidr_column_1, :cidr_column_2
  # or
  t.column :cidr_column, :cidr
end
```

### MACADDR

```ruby
create_table :testing do |t|
  t.macaddr :macaddr_column
  # or
  t.macaddr :macaddr_column_1, :macaddr_column_2
  # or
  t.column :macaddr_column, :macaddr
end
```

### UUID

```ruby
create_table :testing do |t|
  t.uuid :uuid_column
  # or
  t.uuid :uuid_column_1, :uuid_column_2
  # or
  t.column :uuid_column, :uuid
end
```

### Arrays
Arrays are created from any ActiveRecord supported datatype (including
ones added by postgre\_ext), and respect length constraints

```ruby
create_table :testing do |t|
  t.integer :int_array, :array => true
  # integer[]
  t.integer :int_array, :array => true, :length => 2
  # smallint[]
  t.string :macaddr_column_1, :array => true, :length => 30
  # char varying(30)[]
end
```

## Type Casting support

### INET and CIDR
INET and CIDR values are converted to
[IPAddr](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/ipaddr/rdoc/IPAddr.html)
objects when retrieved from the database, or set as a string.

```ruby
create_table :inet_examples do |t|
  t.inet :ip_address
end

class InetExample < ActiveRecord::Base
end

inetExample = InetExample.new
inetExample.ip_address = '127.0.0.0/24'
inetExample.ip_address
# => #<IPAddr: IPv4:127.0.0.0/255.255.255.0> 
inetExample.save

inet_2 = InetExample.first
inet_2.ip_address
# => #<IPAddr: IPv4:127.0.0.0/255.255.255.0> 
```

### Arrays
Array values can be set with Array objects. Any array stored in the
database will be converted to a properly casted array of values on the
way out.

```ruby
create_table :people do |t|
  t.integer :favorite_numbers, :array => true
end

class Person < ActiveRecord::Base
end

person = Person.new
person.favorite_numbers = [1,2,3]
person.favorite_numbers
# => [1,2,3]
person.save

person_2 = Person.first
person_2.favorite_numbers
# => [1,2,3]
person_2.favorite_numbers.first.class
# => Fixnum
```


## Authors

Dan McClain [twitter](http://twitter.com/_danmcclain) [github](http://github.com/danmcclain)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
