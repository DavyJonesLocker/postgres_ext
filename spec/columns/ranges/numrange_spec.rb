require 'spec_helper'

describe 'numrange column' do
  let!(:adapter) { ActiveRecord::Base.connection }
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
