# encoding: utf-8

require 'spec_helper'

describe 'Range column' do
  let!(:adapter) { ActiveRecord::Base.connection }

  context 'Numeric range' do
    let!(:numeric_range_column) { ActiveRecord::ConnectionAdapters::PostgreSQLColumn.new 'field', nil, 'numrange'}
    describe '#type_class' do
      it 'converts an end-inclusive PostgreSQL integer range to a Ruby range' do
        numeric_range_column.type_cast('[0,4.1]').should eq 0.0..4.1
      end

      it 'converts an end-exclusive PostgreSQL integer range to a Ruby range' do
        numeric_range_column.type_cast('[0,4)').should eq 0.0...4.0
      end

      it 'converts an infinite PostgreSQL integer range to a Ruby range' do
        numeric_range_column.type_cast('(,4)').should eq -(1.0/0.0)...4.0
        numeric_range_column.type_cast('[0,)').should eq 0.0..(1.0/0.0)
      end
    end

    describe 'Numeric range to SQL statment conversion' do
      it 'returns an end-inclusive PostgreSQL range' do
        value = numeric_range_column.type_cast('[0,4.0]')
        adapter.type_cast(value, numeric_range_column).should eq '[0.0,4.0]'
      end
      it 'returns an end-exclusive PostgreSQL range' do
        value = numeric_range_column.type_cast('[0,4.0)')
        adapter.type_cast(value, numeric_range_column).should eq '[0.0,4.0)'
      end
      it 'converts an infinite PostgreSQL integer range to a Ruby range' do
        value = numeric_range_column.type_cast('(,4.0)')
        adapter.type_cast(value, numeric_range_column).should eq '(,4.0)'
        value = numeric_range_column.type_cast('[0,)')
        adapter.type_cast(value, numeric_range_column).should eq '[0.0,)'
      end
    end
  end

  context 'Int4 range' do
    let!(:int4_range_column) { ActiveRecord::ConnectionAdapters::PostgreSQLColumn.new 'field', nil, 'int4range'}
    describe '#type_class' do
      it 'converts an end-inclusive PostgreSQL integer range to a Ruby range' do
        int4_range_column.type_cast('[0,4]').should eq 0..4
      end

      it 'converts an end-exclusive PostgreSQL integer range to a Ruby range' do
        int4_range_column.type_cast('[0,4)').should eq 0...4
      end

      it 'converts an infinite PostgreSQL integer range to a Ruby range' do
        int4_range_column.type_cast('(,4)').should eq -(1.0/0.0)...4
        int4_range_column.type_cast('[0,)').should eq 0..(1.0/0.0)
      end
    end

    describe 'int4 range to SQL statment conversion' do
      it 'returns an end-inclusive PostgreSQL range' do
        value = int4_range_column.type_cast('[0,4]')
        adapter.type_cast(value, int4_range_column).should eq '[0,4]'
      end
      it 'returns an end-exclusive PostgreSQL range' do
        value = int4_range_column.type_cast('[0,4)')
        adapter.type_cast(value, int4_range_column).should eq '[0,4)'
      end
      it 'converts an infinite PostgreSQL integer range to a Ruby range' do
        value = int4_range_column.type_cast('(,4)')
        adapter.type_cast(value, int4_range_column).should eq '(,4)'
        value = int4_range_column.type_cast('[0,)')
        adapter.type_cast(value, int4_range_column).should eq '[0,)'
      end
    end
  end

  context 'Int8 range' do
    let!(:int8_range_column) { ActiveRecord::ConnectionAdapters::PostgreSQLColumn.new 'field', nil, 'int8range'}
    describe '#type_class' do
      it 'converts an end-inclusive PostgreSQL integer range to a Ruby range' do
        int8_range_column.type_cast('[0,4]').should eq 0..4
      end

      it 'converts an end-exclusive PostgreSQL integer range to a Ruby range' do
        int8_range_column.type_cast('[0,4)').should eq 0...4
      end

      it 'converts an infinite PostgreSQL integer range to a Ruby range' do
        int8_range_column.type_cast('(,4)').should eq -(1.0/0.0)...4
        int8_range_column.type_cast('[0,)').should eq 0..(1.0/0.0)
      end
    end

    describe 'int8 range to SQL statment conversion' do
      it 'returns an end-inclusive PostgreSQL range' do
        value = int8_range_column.type_cast('[0,4]')
        adapter.type_cast(value, int8_range_column).should eq '[0,4]'
      end
      it 'returns an end-exclusive PostgreSQL range' do
        value = int8_range_column.type_cast('[0,4)')
        adapter.type_cast(value, int8_range_column).should eq '[0,4)'
      end
      it 'converts an infinite PostgreSQL integer range to a Ruby range' do
        value = int8_range_column.type_cast('(,4)')
        adapter.type_cast(value, int8_range_column).should eq '(,4)'
        value = int8_range_column.type_cast('[0,)')
        adapter.type_cast(value, int8_range_column).should eq '[0,)'
      end
    end
  end

  context 'date range' do
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
end
