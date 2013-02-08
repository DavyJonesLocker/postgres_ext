# Indexes

## Index types

Postgres\_ext allows you to specify index type and index operator
class at index creation.

```ruby
add_index :table_name, :column, :index_type => :gin
add_index :table_name, :column, :index_type => :gin, :index_opclass => :gin_trgm_ops
```

## Where clauses

Postgres\_ext allows you to specify a where clause at index creation.

```ruby
add_index :table_name, :column, :where => 'column < 50'
```
