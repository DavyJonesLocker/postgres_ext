# Type Casting support

## INET and CIDR
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

## Arrays
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

## Ranges
Like array objects, postgres\_ext supports range types as well.
Numrange, in4range, int8range, daterange, tsrange, and tstzrange are all
supported, but there are some notable caveats.

### Int and Date ranges
As integers and days are discrete measurements, PostgreSQL will
normalize these ranges as they are store in the database. PostgreSQL
will convert end-inclusive ranges to end-exclusive, meaning that `0..4`
becomes `0...5`. Developers should be aware of this when using integer
and date ranges, since ruby will treat these ranges differently from
PostgreSQL. 

### Timestamp with and without timezone
Ruby/Rails 3.2.x does not support datetime ranges that begin or end with
infinity. Rails 4 has patched datetime and time so that infinity
terminated ranges work, but currently postgres\_ext has not patched the
required methods.
