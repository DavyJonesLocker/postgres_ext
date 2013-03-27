require 'spec_helper'

describe 'Range migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :data_types }
  context 'integer range' do
    it 'creates an int4range column' do
      lambda do
        connection.create_table :data_types do |t|
          t.integer_range :int_range_1
          t.integer_range :int_range_2, :int_range_3
          t.column :int_range_4, :integer_range
        end
      end.should_not raise_exception

      columns = connection.columns(:data_types)
      int_range_1 = columns.detect { |c| c.name == 'int_range_1'}
      int_range_2 = columns.detect { |c| c.name == 'int_range_2'}
      int_range_3 = columns.detect { |c| c.name == 'int_range_3'}
      int_range_4 = columns.detect { |c| c.name == 'int_range_4'}

      int_range_1.sql_type.should eq 'int4range'
      int_range_2.sql_type.should eq 'int4range'
      int_range_3.sql_type.should eq 'int4range'
      int_range_4.sql_type.should eq 'int4range'
    end

    it 'creates an int8range column' do
      lambda do
        connection.create_table :data_types do |t|
          t.integer_range :int_range_1, :limit => 8
          t.integer_range :int_range_2, :int_range_3, :limit => 5
          t.column :int_range_4, :integer_range, :limit => 7
        end
      end.should_not raise_exception

      columns = connection.columns(:data_types)
      int_range_1 = columns.detect { |c| c.name == 'int_range_1'}
      int_range_2 = columns.detect { |c| c.name == 'int_range_2'}
      int_range_3 = columns.detect { |c| c.name == 'int_range_3'}
      int_range_4 = columns.detect { |c| c.name == 'int_range_4'}

      int_range_1.sql_type.should eq 'int8range'
      int_range_2.sql_type.should eq 'int8range'
      int_range_3.sql_type.should eq 'int8range'
      int_range_4.sql_type.should eq 'int8range'
    end
  end
end
