require 'spec_helper'

describe 'numrange schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :testings }

  it 'correctly generates numrange column statements' do
    stream = StringIO.new
    connection.create_table :testings do |t|
      t.numrange :range
    end

    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /t\.numrange "range"/
  end
end
