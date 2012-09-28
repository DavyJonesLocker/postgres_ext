require 'spec_helper'

describe 'UUID migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  it 'creates an uuid column' do
    lambda do
      connection.create_table :data_types do |t|
        t.uuid :uuid_1
        t.uuid :uuid_2, :uuid_3
        t.column :uuid_4, :uuid
      end
    end.should_not raise_exception

    columns = connection.columns(:data_types)
    uuid_1 = columns.detect { |c| c.name == 'uuid_1'}
    uuid_2 = columns.detect { |c| c.name == 'uuid_2'}
    uuid_3 = columns.detect { |c| c.name == 'uuid_3'}
    uuid_4 = columns.detect { |c| c.name == 'uuid_4'}

    uuid_1.sql_type.should eq 'uuid'
    uuid_2.sql_type.should eq 'uuid'
    uuid_3.sql_type.should eq 'uuid'
    uuid_4.sql_type.should eq 'uuid'
  end
end
