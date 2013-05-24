require 'spec_helper'

describe 'tsrange column' do
  let!(:adapter) { ActiveRecord::Base.connection }
  let!(:ts_range_column) { ActiveRecord::ConnectionAdapters::PostgreSQLColumn.new 'field', nil, 'tsrange'}

  describe '#type_class' do
    it 'converts an end-inclusive PostgreSQL integer range to a Ruby range' do
      ts_range_column.type_cast('[2011-01-01 12:34:00,2012-01-31 08:00:01]').should eq Time.new(2011, 01, 01, 12, 34)..Time.new(2012, 01, 31, 8, 0, 1)
    end

    it 'converts an end-exclusive PostgreSQL integer range to a Ruby range' do
      ts_range_column.type_cast('[2011-01-01 12:34:00,2012-01-31 08:00:01)').should eq Time.new(2011, 01, 01, 12, 34)...Time.new(2012, 01, 31, 8, 0, 1)
    end

    #it 'converts an infinite PostgreSQL integer range to a Ruby range' do
    ## Cannot have a range from -Infinity to a ts
    ## ts_range_column.type_cast('(,2011-01-01)').should eq -(1.0/0.0)...4
    #ts_range_column.type_cast('[2011-01-01 12:34:00,)').should eq Time.new(2011,01,01, 12, 34)..(1.0/0.0)
    #end
  end

  describe 'Time range to SQL statment conversion' do
    it 'returns an end-inclusive PostgreSQL range' do
      value = ts_range_column.type_cast('[2011-01-01 12:34:00,2012-01-31 08:00:01]')
      adapter.type_cast(value, ts_range_column).should eq '[2011-01-01 12:34:00,2012-01-31 08:00:01]'
    end
    it 'returns an end-exclusive PostgreSQL range' do
      value = ts_range_column.type_cast('[2011-01-01 12:34:00,2012-01-31 08:00:01)')
      adapter.type_cast(value, ts_range_column).should eq '[2011-01-01 12:34:00,2012-01-31 08:00:01)'
    end
    #it 'converts an infinite PostgreSQL integer range to a Ruby range' do
    #value = ts_range_column.type_cast('[2011-01-01 12:34:00,)')
    #adapter.type_cast(value, ts_range_column).should eq '[2011-01-01 12:34:00,)'
    #end
  end
end
