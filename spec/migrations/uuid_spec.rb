require 'spec_helper'

describe 'UUID migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  it 'creates an uuid column' do
    lambda do
      connection.create_table :data_types do |t|
        t.uuid :cidr_1
        t.uuid :cidr_2, :cidr_3
        t.column :cidr_4, :uuid
      end
    end.should_not raise_exception

    columns = connection.columns(:data_types)
    cidr_1 = columns.detect { |c| c.name == 'cidr_1'}
    cidr_2 = columns.detect { |c| c.name == 'cidr_2'}
    cidr_3 = columns.detect { |c| c.name == 'cidr_3'}
    cidr_4 = columns.detect { |c| c.name == 'cidr_4'}

    cidr_1.sql_type.should eq 'uuid'
    cidr_2.sql_type.should eq 'uuid'
    cidr_3.sql_type.should eq 'uuid'
    cidr_4.sql_type.should eq 'uuid'
  end
end
