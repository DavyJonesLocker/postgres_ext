require 'spec_helper'

describe 'CIDR array migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  it 'creates an cidr array column' do
    lambda do
      connection.create_table :data_types do |t|
        t.cidr_array :cidr_array_1
        t.cidr_array :cidr_array_2, :cidr_array_3
        t.column :cidr_array_4, :cidr_array
      end
    end.should_not raise_exception

    columns = connection.columns(:data_types)
    cidr_array_1 = columns.detect { |c| c.name == 'cidr_array_1'}
    cidr_array_2 = columns.detect { |c| c.name == 'cidr_array_2'}
    cidr_array_3 = columns.detect { |c| c.name == 'cidr_array_3'}
    cidr_array_4 = columns.detect { |c| c.name == 'cidr_array_4'}

    cidr_array_1.sql_type.should eq 'cidr[]'
    cidr_array_2.sql_type.should eq 'cidr[]'
    cidr_array_3.sql_type.should eq 'cidr[]'
    cidr_array_4.sql_type.should eq 'cidr[]'
  end
end
