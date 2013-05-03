require 'spec_helper'

describe 'range schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :testings }
  context 'Numeric ranges' do
    it 'correctly generates numrange column statements' do
      stream = StringIO.new
      connection.create_table :testings do |t|
        t.numrange :range
      end

      ActiveRecord::SchemaDumper.dump(connection, stream)
      output = stream.string

      output.should match /t\.numrange "range"/
    end
  end

  context 'Date ranges' do
    it 'correctly generates daterange column statements' do
      stream = StringIO.new
      connection.create_table :testings do |t|
        t.daterange :range
      end

      ActiveRecord::SchemaDumper.dump(connection, stream)
      output = stream.string

      output.should match /t\.daterange "range"/
    end
  end

  context 'Int4 ranges' do
    it 'correctly generates int4range column statements' do
      stream = StringIO.new
      connection.create_table :testings do |t|
        t.int4range :range
      end

      ActiveRecord::SchemaDumper.dump(connection, stream)
      output = stream.string

      output.should match /t\.int4range "range"/
    end
  end

  context 'Int8 ranges' do
    it 'correctly generates int8range column statements' do
      stream = StringIO.new
      connection.create_table :testings do |t|
        t.int8range :range
      end

      ActiveRecord::SchemaDumper.dump(connection, stream)
      output = stream.string

      output.should match /t\.int8range "range"/
    end
  end

  context 'Timestamp (without time zone) ranges' do
    it 'correctly generates tsrange column statements' do
      stream = StringIO.new
      connection.create_table :testings do |t|
        t.tsrange :range
      end

      ActiveRecord::SchemaDumper.dump(connection, stream)
      output = stream.string

      output.should match /t\.tsrange "range"/
    end
  end

  context 'Timestamp (with time zone) ranges' do
    it 'correctly generates tstzrange column statements' do
      stream = StringIO.new
      connection.create_table :testings do |t|
        t.tstzrange :range
      end

      ActiveRecord::SchemaDumper.dump(connection, stream)
      output = stream.string

      output.should match /t\.tstzrange "range"/
    end
  end
end
