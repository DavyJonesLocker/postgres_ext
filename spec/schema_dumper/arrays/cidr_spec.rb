require 'spec_helper'

describe 'CIDR array schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  it 'correctly generates cidr array column statements' do
    stream = StringIO.new
    connection.create_table :testings do |t|
      t.cidr_array :network_array_column
    end

    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /t\.cidr_array/
  end
end
