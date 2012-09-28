require 'spec_helper'

describe 'UUID schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  it 'correctly generates uuid column statements' do
    stream = StringIO.new
    connection.create_table :testings do |t|
      t.uuid :uuid_column
    end

    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /t\.uuid/
  end
end
