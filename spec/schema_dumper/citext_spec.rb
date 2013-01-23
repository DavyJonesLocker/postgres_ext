require 'spec_helper'

describe 'CITEXT schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :testings }
  it 'correctly generates citext column statements' do
    stream = StringIO.new
    connection.create_table :testings do |t|
      t.citext :citext_column
    end

    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /t\.citext/
  end
end
