require 'spec_helper'

describe 'tsrange migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :data_types }

  it 'creates an tsrange column' do
    lambda do
      connection.create_table :data_types do |t|
        t.tsrange :ts_range_1
        t.tsrange :ts_range_2, :ts_range_3
        t.column :ts_range_4, :tsrange
      end
    end.should_not raise_exception

    columns = connection.columns(:data_types)
    ts_range_1 = columns.detect { |c| c.name == 'ts_range_1'}
    ts_range_2 = columns.detect { |c| c.name == 'ts_range_2'}
    ts_range_3 = columns.detect { |c| c.name == 'ts_range_3'}
    ts_range_4 = columns.detect { |c| c.name == 'ts_range_4'}

    ts_range_1.sql_type.should eq 'tsrange'
    ts_range_2.sql_type.should eq 'tsrange'
    ts_range_3.sql_type.should eq 'tsrange'
    ts_range_4.sql_type.should eq 'tsrange'
  end
end
