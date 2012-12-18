require 'spec_helper'

describe 'Index schema dumper' do
  let!(:connection) { ActiveRecord::Base.connection }

  before do
    connection.create_table :index_types do |t|
      t.integer :col1, :array => true
      t.integer :col2
      t.text    :col3
    end
  end

  after { connection.drop_table :index_types }

  it 'handles index type parameters' do
    connection.add_index(:index_types, :col1, :index_type => :gin)

    stream = StringIO.new
    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /:index_type => :gin/
    output.should_not match /:index_type => :btree/
    output.should_not match /:index_opclass =>/
  end

  it 'handles index where clauses' do
    connection.add_index(:index_types, :col2, :where => '(col2 > 50)')

    stream = StringIO.new
    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /:where => "\(col2 > 50\)"/
  end

  it 'dumps index operator classes' do
    connection.add_index(:index_types, :col3, :index_type => :gin, :index_opclass => :gin_trgm_ops)

    stream = StringIO.new
    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /:index_type => :gin,\s+:index_opclass => :gin_trgm_ops/
  end
end
