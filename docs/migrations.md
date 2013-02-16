# Migration/Schema.rb support

## INET

```ruby
create_table :testing do |t|
  t.inet :inet_column
  # or
  t.inet :inet_column_1, :inet_column_2
  # or
  t.column :inet_column, :inet
end
```

## CIDR

```ruby
create_table :testing do |t|
  t.cidr :cidr_column
  # or
  t.cidr :cidr_column_1, :cidr_column_2
  # or
  t.column :cidr_column, :cidr
end
```

## MACADDR

```ruby
create_table :testing do |t|
  t.macaddr :macaddr_column
  # or
  t.macaddr :macaddr_column_1, :macaddr_column_2
  # or
  t.column :macaddr_column, :macaddr
end
```

## UUID

```ruby
create_table :testing do |t|
  t.uuid :uuid_column
  # or
  t.uuid :uuid_column_1, :uuid_column_2
  # or
  t.column :uuid_column, :uuid
end
```

## CITEXT

```ruby
create_table :testing do |t|
  t.citext :citext_column
  # or
  t.citext :citext_column_1, :citext_column_2
  # or
  t.column :citext_column, :citext
end
```

## Arrays
Arrays are created from any ActiveRecord supported datatype (including
ones added by postgres\_ext), and respect length constraints

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

### Converting to Arrays

If you have an existing column with a string-delimited array (e.g. 'val1 val2 val3') convert that data using SQL in your migration.

```ruby
class AddLinkedArticleIdsToLinkSet < ActiveRecord::Migration
  def change
    add_column :link_sets, :linked_article_ids, :integer, :array => true, :default => []
    execute <<-eos
    UPDATE link_sets
    SET linked_article_ids = cast (string_to_array(linked_articles_string, ' ') as integer[])
    eos
  end
end
````
