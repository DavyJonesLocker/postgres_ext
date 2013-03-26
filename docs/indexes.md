# Indexes

## Index types

Postgres\_ext allows you to specify index type and index operator
class at index creation.

```ruby
add_index :table_name, :column, :using => :gin
add_index :table_name, :column, :using => :gin, :index_opclass => :gin_trgm_ops
```

## Where clauses

Postgres\_ext allows you to specify a where clause at index creation.

```ruby
add_index :table_name, :column, :where => 'column < 50'
```

## Concurrent Indexes

Postgres\_ext allows you to create indexes concurrently using the
`:algorithm` option

```ruby
add_index :table_name, :column, :algorithm => :concurrently
```
