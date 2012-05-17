require 'spec_helper'

describe 'Array column' do
  let!(:integer_array_column) { ActiveRecord::ConnectionAdapters::PostgreSQLColumn.new 'field', nil, 'integer[]'}
  let!(:string_array_column) { ActiveRecord::ConnectionAdapters::PostgreSQLColumn.new 'field', nil, 'character varying(255)[]'}
  let!(:adapter) { ActiveRecord::Base.connection }

  context 'string array' do
    describe '#type_class' do
      context 'has null value' do
        it 'converts the PostgreSQL value to an array with a nil value' do
          string_array_column.type_cast('{1,NULL,"NULL"}').should eq ['1',nil,'NULL']
        end
      end

      context 'corner cases, strings with commas and quotations' do
        it 'converts the PostgreSQL value containing escaped " to an array' do
          string_array_column.type_cast('{"has \" quote",another value}').should eq ['has " quote', 'another value']
        end
      end
    end
  end

  context 'integer array' do
    describe '#type_class' do
      context 'has null value' do
        it 'converts a Postgres Array with nulls in it' do
          integer_array_column.type_cast('{1,NULL,2}').should eq [1,nil,2]
        end
      end
      context 'one dimensional array' do
        it 'converts a PostgreSQL array value to an array of integers' do
          integer_array_column.type_cast('{1,2,3,4}').should eq [1,2,3,4]
        end
      end

      context 'multi dimensional array' do
        it 'converts a PostgreSQL array value to an array of integer arrays' do
          integer_array_column.type_cast('{1,{2,3},4}').should eq [1,[2,3],4]
        end
      end
      context 'multi dimensional array with multiple arrays' do
        it 'converts a PostgreSQL array value to an array of integer arrays' do
          integer_array_column.type_cast('{1,{2,3},{4}}').should eq [1,[2,3],[4]]
        end
      end
    end

    describe 'integer array to SQL statment conversion' do
      context 'contains a nil value' do
        it 'returns a PostgreSQL array' do
          value = integer_array_column.type_cast('{1,NULL,2}')
          adapter.type_cast(value, integer_array_column).should eq '{1,NULL,2}'
        end
      end
      context 'one dimensional array' do
        it 'returns a PostgreSQL array' do
          value = integer_array_column.type_cast('{1,2,3,4}')
          adapter.type_cast(value, integer_array_column).should eq '{1,2,3,4}'
        end
      end
      context 'multi dimensional array' do
        it 'returns a PostgreSQL array' do
          value = integer_array_column.type_cast('{1,{2,3},4}')
          adapter.type_cast(value, integer_array_column).should eq '{1,{2,3},4}'
        end
      end
    end
  end
end
