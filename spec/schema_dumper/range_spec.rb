require 'spec_helper'

describe 'range schema dump' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :testings }
  context 'Numeric ranges' do
    it 'correctly generates numrange column statements' do
      stream = StringIO.new
      connection.create_table :testings do |t|
        t.numeric_range :range
      end

      ActiveRecord::SchemaDumper.dump(connection, stream)
      output = stream.string

      output.should match /t\.numeric_range "range"/
    end
  end
end
