require 'spec_helper'

describe 'int8range migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :data_types }

  it 'creates an numrange column' do
    lambda do
      connection.create_table :data_types do |t|
        t.int8range :range_1
        t.int8range :range_2, :range_3
        t.column :range_4, :int8range
      end
    end.should_not raise_exception

    columns = connection.columns(:data_types)
    range_1 = columns.detect { |c| c.name == 'range_1'}
    range_2 = columns.detect { |c| c.name == 'range_2'}
    range_3 = columns.detect { |c| c.name == 'range_3'}
    range_4 = columns.detect { |c| c.name == 'range_4'}

    range_1.sql_type.should eq 'int8range'
    range_2.sql_type.should eq 'int8range'
    range_3.sql_type.should eq 'int8range'
    range_4.sql_type.should eq 'int8range'
  end
end
