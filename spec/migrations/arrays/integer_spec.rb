require 'spec_helper'

describe 'INTEGER array migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  it 'creates an integer array column' do
    lambda do
      connection.create_table :data_types do |t|
        t.integer_array :int_array_1
        t.integer_array :int_array_2, :int_array_3
        t.column :int_array_4, :integer_array
      end
    end.should_not raise_exception

    columns = connection.columns(:data_types)
    int_array_1 = columns.detect { |c| c.name == 'int_array_1'}
    int_array_2 = columns.detect { |c| c.name == 'int_array_2'}
    int_array_3 = columns.detect { |c| c.name == 'int_array_3'}
    int_array_4 = columns.detect { |c| c.name == 'int_array_4'}

    int_array_1.sql_type.should eq 'integer[]'
    int_array_2.sql_type.should eq 'integer[]'
    int_array_3.sql_type.should eq 'integer[]'
    int_array_4.sql_type.should eq 'integer[]'
  end

  it 'adheres to the limit option' do
    lambda do
      connection.create_table :data_types do |t|
        t.integer_array :one_int_array, :limit => 1
        t.integer_array :four_int_array, :limit => 4
        t.integer_array :eight_int_array, :limit => 8
        t.integer_array :eleven_int_array, :limit => 11
      end
    end.should_not raise_exception
    columns = connection.columns(:data_types)
    one    = columns.detect { |c| c.name == 'one_int_array'}
    four   = columns.detect { |c| c.name == 'four_int_array'}
    eight  = columns.detect { |c| c.name == 'eight_int_array'}
    eleven = columns.detect { |c| c.name == 'eleven_int_array'}

    one.sql_type.should eq 'smallint[]'
    four.sql_type.should eq 'integer[]'
    eight.sql_type.should eq 'bigint[]'
    eleven.sql_type.should eq 'integer[]'
  end
end
