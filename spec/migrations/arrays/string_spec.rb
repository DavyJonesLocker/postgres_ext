require 'spec_helper'

describe 'String array migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  it 'creates a string array column' do
    lambda do
      connection.create_table :data_types do |t|
        t.string_array :string_array_1
        t.string_array :string_array_2, :string_array_3
        t.column :string_array_4, :string_array
      end
    end.should_not raise_exception

    columns = connection.columns(:data_types)
    string_array_1 = columns.detect { |c| c.name == 'string_array_1'}
    string_array_2 = columns.detect { |c| c.name == 'string_array_2'}
    string_array_3 = columns.detect { |c| c.name == 'string_array_3'}
    string_array_4 = columns.detect { |c| c.name == 'string_array_4'}

    string_array_1.sql_type.should eq 'character varying(255)[]'
    string_array_2.sql_type.should eq 'character varying(255)[]'
    string_array_3.sql_type.should eq 'character varying(255)[]'
    string_array_4.sql_type.should eq 'character varying(255)[]'
  end

  it 'adheres to the limit option' do
    lambda do
      connection.create_table :data_types do |t|
        t.string_array :one_string_array, :limit => 1
      end
    end.should_not raise_exception
    columns = connection.columns(:data_types)
    one    = columns.detect { |c| c.name == 'one_string_array'}

    one.sql_type.should eq 'character varying(1)[]'
  end
end
