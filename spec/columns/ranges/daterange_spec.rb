require 'spec_helper'

describe 'daterange column' do
  let!(:adapter) { ActiveRecord::Base.connection }
  let!(:date_range_column) { ActiveRecord::ConnectionAdapters::PostgreSQLColumn.new 'field', nil, 'daterange'}

  describe '#type_class' do
    it 'converts an end-inclusive PostgreSQL integer range to a Ruby range' do
      date_range_column.type_cast('[2011-01-01,2012-01-31]').should eq Date.new(2011,01,01)..Date.new(2012,01,31)
    end

    it 'converts an end-exclusive PostgreSQL integer range to a Ruby range' do
      date_range_column.type_cast('[2011-01-01,2012-01-31)').should eq Date.new(2011,01,01)...Date.new(2012,01,31)
    end

    it 'converts an infinite PostgreSQL integer range to a Ruby range' do
      # Cannot have a range from -Infinity to a date
      # date_range_column.type_cast('(,2011-01-01)').should eq -(1.0/0.0)...4
      date_range_column.type_cast('[2011-01-01,)').should eq Date.new(2011,01,01)..(1.0/0.0)
    end
  end

  describe 'date range to SQL statment conversion' do
    it 'returns an end-inclusive PostgreSQL range' do
      value = date_range_column.type_cast('[2011-01-01,2012-01-31]')
      adapter.type_cast(value, date_range_column).should eq '[2011-01-01,2012-01-31]'
    end
    it 'returns an end-exclusive PostgreSQL range' do
      value = date_range_column.type_cast('[2011-01-01,2012-01-31)')
      adapter.type_cast(value, date_range_column).should eq '[2011-01-01,2012-01-31)'
    end
    it 'converts an infinite PostgreSQL integer range to a Ruby range' do
      value = date_range_column.type_cast('[2011-01-01,)')
      adapter.type_cast(value, date_range_column).should eq '[2011-01-01,)'
    end
  end
end
