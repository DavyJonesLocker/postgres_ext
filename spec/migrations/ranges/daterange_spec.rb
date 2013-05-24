require 'spec_helper'

describe 'daterange migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :data_types }

  it 'creates an daterange column' do
    lambda do
      connection.create_table :data_types do |t|
        t.daterange :date_range_1
        t.daterange :date_range_2, :date_range_3
        t.column :date_range_4, :daterange
      end
    end.should_not raise_exception

    columns = connection.columns(:data_types)
    date_range_1 = columns.detect { |c| c.name == 'date_range_1'}
    date_range_2 = columns.detect { |c| c.name == 'date_range_2'}
    date_range_3 = columns.detect { |c| c.name == 'date_range_3'}
    date_range_4 = columns.detect { |c| c.name == 'date_range_4'}

    date_range_1.sql_type.should eq 'daterange'
    date_range_2.sql_type.should eq 'daterange'
    date_range_3.sql_type.should eq 'daterange'
    date_range_4.sql_type.should eq 'daterange'
  end
end
