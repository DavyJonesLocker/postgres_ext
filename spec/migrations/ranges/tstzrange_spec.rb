require 'spec_helper'

describe 'tstzrange migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :data_types }

  it 'creates an tstzrange column' do
    lambda do
      connection.create_table :data_types do |t|
        t.tstzrange :tstz_range_1
        t.tstzrange :tstz_range_2, :tstz_range_3
        t.column :tstz_range_4, :tstzrange
      end
    end.should_not raise_exception

    columns = connection.columns(:data_types)
    tstz_range_1 = columns.detect { |c| c.name == 'tstz_range_1'}
    tstz_range_2 = columns.detect { |c| c.name == 'tstz_range_2'}
    tstz_range_3 = columns.detect { |c| c.name == 'tstz_range_3'}
    tstz_range_4 = columns.detect { |c| c.name == 'tstz_range_4'}

    tstz_range_1.sql_type.should eq 'tstzrange'
    tstz_range_2.sql_type.should eq 'tstzrange'
    tstz_range_3.sql_type.should eq 'tstzrange'
    tstz_range_4.sql_type.should eq 'tstzrange'
  end
end
