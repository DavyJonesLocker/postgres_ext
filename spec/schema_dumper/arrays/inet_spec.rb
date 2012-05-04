require 'spec_helper'

describe 'INET array schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  it 'correctly generates inet array column statements' do
    stream = StringIO.new
    connection.create_table :testings do |t|
      t.inet_array :ip_array_column
    end

    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /t\.inet_array/
  end
end
