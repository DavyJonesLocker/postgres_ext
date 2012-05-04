require 'spec_helper'

describe 'String array schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  it 'generates string_array columns in schema dumps' do
    stream = StringIO.new

    connection.create_table :testings do |t|
      t.string_array :str_array
    end

    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /t\.string_array/
  end

  it 'generates limit options on integer_array columns' do
    stream = StringIO.new

    connection.create_table :testings do |t|
      t.string_array :str_array, :limit => 1
    end

    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match %r{t\.string_array.*str_array.*:limit => 1}
  end
end
