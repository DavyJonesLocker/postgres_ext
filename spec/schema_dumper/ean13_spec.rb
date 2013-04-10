require 'spec_helper'

describe 'ean13 schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :testings }
  it 'correctly generates ean13 column statements' do
    stream = StringIO.new
    connection.create_table :testings do |t|
      t.ean13 :ean13_column
    end

    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /t\.ean13/
  end
end
