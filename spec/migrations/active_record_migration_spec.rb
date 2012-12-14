require 'spec_helper'

describe 'ActiveRecord Migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  it 'creates non-postgres_ext columns' do

    lambda do
      connection.create_table :generic_data_types do |t|
        t.integer :col_1
        t.string :col_2
        t.datetime :col_3
      end
      connection.add_column :generic_data_types, :col_4, :text
    end.should_not raise_exception

    columns = connection.columns(:generic_data_types)
    col_1 = columns.detect { |c| c.name == 'col_1'}
    col_2 = columns.detect { |c| c.name == 'col_2'}
    col_3 = columns.detect { |c| c.name == 'col_3'}
    col_4 = columns.detect { |c| c.name == 'col_4'}


    col_1.sql_type.should eq 'integer'
    col_2.sql_type.should eq 'character varying(255)'
    col_3.sql_type.should eq 'timestamp without time zone'
    col_4.sql_type.should eq 'text'
  end
end

