require 'spec_helper'

describe 'INTEGER array schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  it 'generates integer_array columns in schema dumps' do
    stream = StringIO.new

    connection.create_table :testings do |t|
      t.integer_array :int_array
    end

    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /t\.integer_array/
  end

  it 'generates limit options on integer_array columns' do
    stream = StringIO.new

    connection.create_table :testings do |t|
      t.integer_array :one_int_array, :limit => 1
      t.integer_array :eight_int_array, :limit => 8
    end

    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    #Small int has a limit of 2
    output.should match %r{t\.integer_array.*one_int_array.*:limit => 2}
    output.should match %r{t\.integer_array.*eight_int_array.*:limit => 8}
  end
end
