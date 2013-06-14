require 'spec_helper'

describe 'int8range schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :testings }

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
