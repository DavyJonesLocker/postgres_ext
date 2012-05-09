require 'spec_helper'

describe 'INET column' do
  let!(:column) { ActiveRecord::ConnectionAdapters::PostgreSQLColumn.new 'field', nil, 'inet'}
  let!(:adapter) { ActiveRecord::Base.connection }

  describe '#type_class_code' do
    it 'returns code for converting strings to IPAddr' do
      column.type_cast_code('v').should eq 'ActiveRecord::ConnectionAdapters::PostgreSQLColumn.string_to_cidr_address(v)'
    end
  end

  describe 'inet type casting' do
    it 'converts ip strings to NetAddr::CIDR objects' do
      column.type_cast('127.0.0.1').should be_a_kind_of IPAddr
    end
  end

  describe 'inet value conversion for SQL statments' do
    it 'returns the string value of the IPAddr address' do
      value = column.type_cast('127.0.0.1')
      adapter.type_cast(value, column).should eq '127.0.0.1/32'
    end
  end
end
