require 'spec_helper'

describe 'MACADDR array migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  it 'creates an macaddr array column' do
    lambda do
      connection.create_table :data_types do |t|
        t.macaddr_array :macaddr_array_1
        t.macaddr_array :macaddr_array_2, :macaddr_array_3
        t.column :macaddr_array_4, :macaddr_array
      end
    end.should_not raise_exception

    columns = connection.columns(:data_types)
    macaddr_array_1 = columns.detect { |c| c.name == 'macaddr_array_1'}
    macaddr_array_2 = columns.detect { |c| c.name == 'macaddr_array_2'}
    macaddr_array_3 = columns.detect { |c| c.name == 'macaddr_array_3'}
    macaddr_array_4 = columns.detect { |c| c.name == 'macaddr_array_4'}

    macaddr_array_1.sql_type.should eq 'macaddr[]'
    macaddr_array_2.sql_type.should eq 'macaddr[]'
    macaddr_array_3.sql_type.should eq 'macaddr[]'
    macaddr_array_4.sql_type.should eq 'macaddr[]'
  end
end
