require 'spec_helper'

describe 'INET schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  it 'correctly generates inet column statements' do
    stream = StringIO.new
    connection.create_table :testings do |t|
      t.inet :ip_column
    end

    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /t\.inet/
  end
end
