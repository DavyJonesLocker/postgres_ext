# Common Table Expressions (CTEs)

Postgres\_ext adds CTE expression support to ActiveRecord via two
methods:

  * [`Relation#with`](#with)
  * [`Model.from_cte`](#from_cte)

## with

We can add CTEs to queries by chaining `#with` off a relation.
`Relation#with` accepts a hash, and will convert `Relation`s to the
proper SQL in the CTE.

Let's expand a `#with` call to its resulting SQL code:

```ruby
Score.with(my_games: Game.where(id: 1)).joins('JOIN my_games ON scores.game_id = my_games.id')
```

The following will be generated when that relation is evaluated:

```SQL
WITH my_games AS (
SELECT games.*
FROM games
WHERE games.id = 1
)
SELECT *
FROM scores
JOIN my_games
ON scores.games_id = my_games.id
```

You can also do a recursive with:

```ruby
Graph.with.recursive(search_graph:
  "  SELECT g.id, g.link, g.data, 1 AS depth
     FROM graph g
   UNION ALL
     SELECT g.id, g.link, g.data, sg.depth + 1
     FROM graph g, search_graph sg
     WHERE g.id = sg.link").from(:search_graph)
```

## from\_cte

`Model.from_cte` is similiar to `Model.find_by_sql`, taking the CTE
passed in, but allowing you to chain off of it further, instead of just
retrieving the results.

Take the following ActiveRecord call:

```ruby
Score.from_cte('scores_for_game', Score.where(game_id: 1)).where(user_id: 1)
```

The following SQL will be called:

```SQL
WITH scores_for_game AS (
SELECT *
FROM scores
WHERE game_id = 1
)
SELECT *
FROM scores_for_game
WHERE scores_for_game.user_id = 1
```

And will be converted to `Score` objects

# Querying PostgreSQL datatypes

  * [Arrays](#arrays)
  * [INET/CIDR](#inetcidr-queries)

## Arrays

  * [&& - Array Overlap operator](#---array-overlap-operator)
  * [ANY or ALL functions](#any-or-all-functions)

### && - Array Overlap operator

PostgreSQL implements the `&&` operator, known as the overlap operator,
for arrays. The overlap operator returns `t` (true) when two arrays have
one or more elements in common.

```sql
ARRAY[1,2,3] && ARRAY[4,5,6]
-- f

ARRAY[1,2,3] && ARRAY[3,5,6]
-- t
```

Postgres\_ext extends the `ActiveRecord::Relation.where` method similar
to the Rails 4.0 not clause. The easiest way to make a overlap query
would be:

```ruby
User.where.overlap(:nick_names => ['Bob', 'Fred'])
``` 

Postgres\_ext defines `overlap`, an [Arel](https://github.com/rails/arel)
predicate for the `&&` operator. This is utilized by the `where.overlap`
call above.

```ruby
user_arel = User.arel_table

# Execute the query
User.where(user_arel[:tags].overlap(['one','two']))
# => SELECT \"users\".* FROM \"users\" WHERE \"users\".\"tags\" && '{one,two}'
```

### @> - Array Contains operator

PostgreSQL has a contains (`@>`) operator for querying whether or not
a column contain all of the elements of a given array.

```sql
ARRAY[1,2,3] @> ARRAY[3,4]
-- f

ARRAY[1,2,3] @> ARRAY[2,3]
-- t
```

Postgres\_ext extends the `ActiveRecord::Relation.where` method by
adding a `contains` method. To make a contains query, you can do:

```ruby
# Users whose hobbies include both Ice Fishing and Basket Weaving
User.where.contains(:hobbies => ['Ice Fishing', 'Basket Weaving'])
```

Postgres\_ext overrides `contains`, an [Arel](https://github.com/rails/arel)
predicate, to use the `@>` operator for arrays. This is utilized by the
`where.contains` call above.

```ruby
user_arel = User.arel_table

# Execute the query
User.where(user_arel[:tags].contains(['one','two']))
# => SELECT "users".* FROM "users" WHERE "users"."tags" @> '{"one","two"}'
```

### <@ - Array Is Contained By operator

PostgreSQL has an is contained by (`<@`) operator for querying whether or not
the elements in a column are contained within a given array.

```sql
ARRAY[3,4] <@ ARRAY[1,2,3]
-- f

ARRAY[2,3] <@ ARRAY[1,2,3]
-- t
```

Postgres\_ext extends the `ActiveRecord::Relation.where` method by
adding a `contained_in_array` method. For example:

```ruby
# Users whose hobbies are limited to Ice Fishing or Basket Weaving
User.where.contained_in_array(:hobbies => ['Ice Fishing', 'Basket Weaving'])
```

### ANY or ALL functions

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

Postgres\_ext provides a `ActiveRecord::Relation.where.any()` method. The
easiest way to make a ANY query would be:

```ruby
User.where.any(:nick_names => 'Bob')
``` 

There is also an `ActiveRecord::Relation.where.all()` call as well. This
method utilizes the following code to create the query:

We can generate the above query using [Arel](https://github.com/rails/arel)
and generating the Node manually. We would use the following to
accompish this:

```ruby
user_arel = User.arel_table

# Execute the query
User.where(user_arel[:tags].any('test'))
#=> SELECT \"users\".* FROM \"users\" WHERE 'test' = ANY(\"users\".\"tags\")
```

The ALL version of this same predicate can be generated by swapping
`#any()` for `#all()`.

## INET/CIDR Queries

PostgreSQL defines the `<<`, or contained within operator for INET and
CIDR datatypes. The `<<` operator returns `t` (true) if a INET or CIDR
address is contained within the given subnet. 

```sql
inet '192.168.1.6' << inet '10.0.0.0/24'
-- f

inet '192.168.1.6' << inet '192.168.1.0/24'
-- t
```

In addition to contained within, there is also:

 * `<<=` - Contained within or equals
 * `>>` - Contains
 * `>>=` - Contains or equals

Postgres\_ext extends the `ActiveRecord::Relation.where` method similar
to the Rails 4.0 not clause. The easiest way to make a overlap query
would be:

```ruby
User.where.contained_within(:ip => '192.168.1.1/24')
User.where.contained_within_or_equals(:ip => '192.168.1.1/24')
User.where.contains(:ip => '192.168.1.14')
User.where.contains_or_equals(:ip => '192.168.1.14')
``` 

Postgres\_ext defines `contained_within`, an [Arel](https://github.com/rails/arel)
predicate for the `<<` operator.  This is utilized by the
methods above.

```ruby
user_arel = User.arel_table

# Execute the query
User.where(user_arel[:ip_address].contained_within('127.0.0.1/24'))
# => SELECT \"users\".* FROM \"users\" WHERE \"users\".\"ip_address\" << '127.0.0.1/24'
User.where(user_arel[:ip_address].contained_within_or_equals('127.0.0.1/24'))
# => SELECT \"users\".* FROM \"users\" WHERE \"users\".\"ip_address\" <<= '127.0.0.1/24'
User.where(user_arel[:ip_address].contains('127.0.0.1'))
# => SELECT \"users\".* FROM \"users\" WHERE \"users\".\"ip_address\" >> '127.0.0.1'
User.where(user_arel[:ip_address].contains_or_equals('127.0.0.1'))
# => SELECT \"users\".* FROM \"users\" WHERE \"users\".\"ip_address\" >>= '127.0.0.1'
```
