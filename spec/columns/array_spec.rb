require 'spec_helper'

describe 'Array column' do
  let!(:column) { ActiveRecord::ConnectionAdapters::PostgreSQLColumn.new 'field', nil, 'integer[]'}
  let!(:adapter) { ActiveRecord::Base.connection }

  context 'integer array' do
    describe '#type_class' do
      context 'one dimensional array' do
        it 'converts a PostgreSQL array value to an array of integers' do
          column.type_cast('{1,2,3,4}').should eq [1,2,3,4]
        end
      end

      context 'multi dimensional array' do
        it 'converts a PostgreSQL array value to an array of integer arrays' do
          column.type_cast('{1,{2,3},4}').should eq [1,[2,3],4]
        end
      end
    end

    describe 'integer array to SQL statment conversion' do
      context 'one dimensional array' do
        it 'returns a PostgreSQL array' do
          value = column.type_cast('{1,2,3,4}')
          adapter.type_cast(value, column).should eq '{1,2,3,4}'
        end
      end
      context 'multi dimensional array' do
        it 'returns a PostgreSQL array' do
          value = column.type_cast('{1,{2,3},4}')
          adapter.type_cast(value, column).should eq '{1,{2,3},4}'
        end
      end
    end
  end
end
