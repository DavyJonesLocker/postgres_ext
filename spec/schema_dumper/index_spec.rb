require 'spec_helper'

describe 'index schema dumper' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :index_types }
  it 'correctly generates index statements' do
    connection.add_extension('pg_trgm')
    connection.create_table :index_types do |t|
      t.integer :col1, :array => true
      t.integer :col2
      t.text    :col3
    end
    connection.add_index(:index_types, :col1, :index_type => :gin)
    connection.add_index(:index_types, :col2, :where => '(col2 > 50)')
    connection.add_index(:index_types, :col3, :index_type => :gin, :index_opclass => :gin_trgm_ops)

    stream = StringIO.new
    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /:index_type => :gin/
    output.should_not match /:index_type => :btree/
    output.should match /:where => "\(col2 > 50\)"/
    output.should match /:index_type => :gin,\s+:index_opclass => :gin_trgm_ops/
  end
end
