require 'spec_helper'

describe 'extension schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  it 'correctly creates and exports database extensions' do
    stream = StringIO.new
    connection.add_extension 'hstore'

    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /add_extension "hstore"/
  end
end
