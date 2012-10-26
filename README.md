# PostgresExt

Adds support for missing PostgreSQL data types to ActiveRecord.

[![Build Status](https://secure.travis-ci.org/dockyard/postgres_ext.png?branch=master)](http://travis-ci.org/dockyard/postgres_ext)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/dockyard/postgres_ext)

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

Just `require 'postgres_ext'` and use ActiveRecord as you normally would! postgres\_ext extends
ActiveRecord's data type handling.

 * [Migration/Schema.rb support](#migrationschemarb-support)
 * [Type Casting support](#type-casting-support)
 * [Querying PostgreSQL datatypes](#querying-postgresql-datatypes)

### Usage Notes
Take care when dealing with arrays and other types that allow you to
update their value in place. In place changes are not currently tracked
in Rails (see [this issue](https://github.com/rails/rails/issues/6954)).
To track changes that happen via `#<<` or other instance methods, be
sure to call `<attribute>_will_change!` so that Active Record knows to
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
  t.integer :int_array, :array => true, :limit => 2
  # smallint[]
  t.string :macaddr_column_1, :array => true, :limit => 30
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

## Querying PostgreSQL datatypes

  * [Arrays](#arrays-2)
  * [INET/CIDR](#inetcidr)

### Arrays

  * [&& - Array Overlap operator](#---array-overlap-operator)
  * [ANY or ALL functions](#any-or-all-functions)

#### && - Array Overlap operator

PostgreSQL implements the `&&` operator, known as the overlap operator,
for arrays. The overlap operator returns `t` (true) when two arrays have
one or more elements in common.

```sql
ARRAY[1,2,3] && ARRAY[4,5,6]
-- f

ARRAY[1,2,3] && ARRAY[3,5,6]
-- t
```

Postgres\_ext defines `array_overlap`, an [Arel](https://github.com/rails/arel)
predicate for the `&&` operator.

```ruby
user_arel = User.arel_table

User.where(user_arel[:tags].array_overlap(['one','two'])).to_sql
# => SELECT \"users\".* FROM \"users\" WHERE \"users\".\"tags\" && '{one,two}'
```

#### ANY or ALL functions

When querying array columns, you have the ability to see if a predicate
apply's to either *any* element in the array, or *all* elements of the
array. The syntax for these predicates are slightly different then the
normal `where` syntax in PostgreSQL. To see if an array contains the
string `'test'` in any location, you would write the following in SQL

```sql
SELECT *
FROM users
WHERE 'test' = ANY(users.tags)
```

Notice that the column is on the right hand side of the predicate,
instead of the left, because we have to call the `ANY` function on that
column.

We can generate the above query using [Arel](https://github.com/rails/arel)
and generating the Node manually. We would use the following to
accompish this:

```ruby
user_arel = User.arel_table

any_tags_function = Arel::Nodes::NamedFunction.new('ANY', [user_arel[:tags]])
predicate = Arel::Nodes::Equality.new('test', any_tags_function)

User.where(predicate).to_sql
#=> SELECT \"users\".* FROM \"users\" WHERE 'test' = ANY(\"users\".\"tags\")

```

The ALL version of this same predicate can be generated by swap `'ANY'`
for `'ALL'` in the named function.

### INET/CIDR

#### `<<` -- Contained within operator

PostgreSQL defines the `<<`, or contained within operator for INET and
CIDR datatypes. The `<<` operator returns `t` (true) if a INET or CIDR
address is contained within the given subnet. 

```sql
inet '192.168.1.6' << inet '10.0.0.0/24'
-- f

inet '192.168.1.6' << inet '192.168.1.0/24'
-- t
```

Postgres\_ext defines `contained_within`, an [Arel](https://github.com/rails/arel)
predicate for the `<<` operator.

```ruby
user_arel = User.arel_table

User.where(user_arel[:ip_address].contained_witin('127.0.0.1/24')).to_sql
# => SELECT \"users\".* FROM \"users\" WHERE \"users\".\"ip_address\" << '127.0.0.1/24'
```

## Indexes

### Index types

Postgres\_ext allows you to specify an index type at index creation.

```ruby
add_index :table_name, :column, :index_type => :gin
```

### Where clauses

Postgres\_ext allows you to specify a where clause at index creation.

```ruby
add_index :table_name, :column, :where => 'column < 50'
```

## Authors

Dan McClain [twitter](http://twitter.com/_danmcclain) [github](http://github.com/danmcclain)

