require 'spec_helper'

describe 'index schema dumper' do
  let!(:connection) { ActiveRecord::Base.connection }
  it 'correctly generates index statements' do
    connection.create_table :index_types do |t|
      t.integer :col1, :array => true
      t.integer :col2
    end
    connection.add_index(:index_types, :col1, :index_type => :gin)
    connection.add_index(:index_types, :col2, :where => '(col2 > 50)')

    stream = StringIO.new
    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /:index_type => :gin/
    output.should_not match /:index_type => :btree/
    output.should match /:where => "\(col2 > 50\)"/
  end
end
