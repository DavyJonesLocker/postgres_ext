require 'spec_helper'

describe 'Index schema dumper' do
  let!(:connection) { ActiveRecord::Base.connection }

  after do
    [:tag_ids, :lucky_number, :biography].each do |column|
      begin
        connection.remove_index :people, column
      rescue ArgumentError
      end
    end
  end

  it 'handles index type parameters' do
    connection.add_index(:people, :tag_ids, :using => :gin)

    stream = StringIO.new
    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /:using => :gin/
    output.should_not match /:using => :btree/
    output.should_not match /:index_opclass =>/
  end

  it 'handles index where clauses' do
    connection.add_index(:people, :lucky_number, :where => '(lucky_number > 50)')

    stream = StringIO.new
    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /:where => "\(lucky_number > 50\)"/
  end

  it 'dumps index operator classes', :if => ActiveRecord::Base.connection.supports_extensions? do
    connection.add_index(:people, :biography, :using => :gin, :index_opclass => :gin_trgm_ops)

    stream = StringIO.new
    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /:using => :gin,\s+:index_opclass => :gin_trgm_ops/
  end
end
