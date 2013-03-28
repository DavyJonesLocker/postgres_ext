require 'spec_helper'

describe 'range schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :testings }
  context 'Integer ranges' do
    it 'correctly generates int4range column statements' do
      stream = StringIO.new
      connection.create_table :testings do |t|
        t.integer_range :range
      end

      ActiveRecord::SchemaDumper.dump(connection, stream)
      output = stream.string

      output.should match /t\.integer_range "range"/
      output.should_not match /t\.integer_range "range"\s+:limit => 4/ 
    end

    it 'correctly generates int8range column statements' do
      stream = StringIO.new
      connection.create_table :testings do |t|
        t.integer_range :range, :limit => 8
      end

      ActiveRecord::SchemaDumper.dump(connection, stream)
      output = stream.string
      
      output.should match /t\.integer_range "range".*?:limit => 8/
    end
  end
end
