require 'spec_helper'

describe 'MACADDR array schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  it 'correctly generates macaddr array column statements' do
    stream = StringIO.new
    connection.create_table :testings do |t|
      t.macaddr_array :mac_address_array_column
    end

    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /t\.macaddr_array/
  end
end
