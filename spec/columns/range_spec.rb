# encoding: utf-8

require 'spec_helper'

describe 'Range column' do
  let!(:integer_range_column) { ActiveRecord::ConnectionAdapters::PostgreSQLColumn.new 'field', nil, 'int4range'}
  let!(:adapter) { ActiveRecord::Base.connection }

  context 'integer range' do
    describe '#type_class' do
      it 'converts an end-inclusive PostgreSQL integer range to a Ruby range' do
        integer_range_column.type_cast('[0,4]').should eq 0..4
      end

      it 'converts an end-exclusive PostgreSQL integer range to a Ruby range' do
        integer_range_column.type_cast('[0,4)').should eq 0...4
      end

      it 'converts an infinite PostgreSQL integer range to a Ruby range' do
        integer_range_column.type_cast('(,4)').should eq -(1.0/0.0)...4
        integer_range_column.type_cast('[0,)').should eq 0..(1.0/0.0)
      end
    end

    describe 'integer range to SQL statment conversion' do
      pending
    end
  end
end
