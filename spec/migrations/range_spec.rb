require 'spec_helper'

describe 'Range migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :data_types }
  context 'Int4 range' do
    it 'creates an numrange column' do
      lambda do
        connection.create_table :data_types do |t|
          t.int4range :range_1
          t.int4range :range_2, :range_3
          t.column :range_4, :int4range
        end
      end.should_not raise_exception

      columns = connection.columns(:data_types)
      range_1 = columns.detect { |c| c.name == 'range_1'}
      range_2 = columns.detect { |c| c.name == 'range_2'}
      range_3 = columns.detect { |c| c.name == 'range_3'}
      range_4 = columns.detect { |c| c.name == 'range_4'}

      range_1.sql_type.should eq 'int4range'
      range_2.sql_type.should eq 'int4range'
      range_3.sql_type.should eq 'int4range'
      range_4.sql_type.should eq 'int4range'
    end
  end

  context 'Int8 range' do
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

  context 'Numeric range' do
    it 'creates an numrange column' do
      lambda do
        connection.create_table :data_types do |t|
          t.numrange :num_range_1
          t.numrange :num_range_2, :num_range_3
          t.column :num_range_4, :numrange
        end
      end.should_not raise_exception

      columns = connection.columns(:data_types)
      num_range_1 = columns.detect { |c| c.name == 'num_range_1'}
      num_range_2 = columns.detect { |c| c.name == 'num_range_2'}
      num_range_3 = columns.detect { |c| c.name == 'num_range_3'}
      num_range_4 = columns.detect { |c| c.name == 'num_range_4'}

      num_range_1.sql_type.should eq 'numrange'
      num_range_2.sql_type.should eq 'numrange'
      num_range_3.sql_type.should eq 'numrange'
      num_range_4.sql_type.should eq 'numrange'
    end
  end

  context 'Date range' do
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

  context 'Timestamp (without timezone) range' do
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

  context 'Timestamp (with timezone) range' do
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
end
