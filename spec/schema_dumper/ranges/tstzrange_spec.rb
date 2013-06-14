require 'spec_helper'

describe 'tstzrange schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :testings }
  it 'correctly generates tstzrange column statements' do
    stream = StringIO.new
    connection.create_table :testings do |t|
      t.tstzrange :range
    end

    ActiveRecord::SchemaDumper.dump(connection, stream)
    output = stream.string

    output.should match /t\.tstzrange "range"/
  end
end
