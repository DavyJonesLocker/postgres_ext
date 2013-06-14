require 'spec_helper'

describe 'intrange schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :testings }

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
