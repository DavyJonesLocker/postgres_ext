require 'spec_helper'

describe 'int4range column' do
  let!(:adapter) { ActiveRecord::Base.connection }
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
