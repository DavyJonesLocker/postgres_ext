require 'spec_helper'

describe 'tsrange schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :testings }

  it 'correctly generates tsrange column statements' do
    stream = StringIO.new
    connection.create_table :testings do |t|
      t.tsrange :range
    end

    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /t\.tsrange "range"/
  end
end
