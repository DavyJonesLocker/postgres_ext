require 'spec_helper'

describe 'Schema dumper for extended types' do
  let!(:connection) { ActiveRecord::Base.connection }
  describe 'Inet schema dump' do
    it 'correctly generates inet column statements' do
      stream = StringIO.new
      connection.create_table :testings do |t|
        t.inet :inet_column
      end

      ActiveRecord::SchemaDumper.dump(connection, stream)
      output = stream.string

      output.should match /inet/
    end
  end
end
