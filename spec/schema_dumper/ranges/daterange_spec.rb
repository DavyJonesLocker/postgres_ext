require 'spec_helper'

describe 'daterange schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :testings }

  it 'correctly generates daterange column statements' do
    stream = StringIO.new
    connection.create_table :testings do |t|
      t.daterange :range
    end

    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /t\.daterange "range"/
  end
end
