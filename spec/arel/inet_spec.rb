require 'spec_helper'

describe 'INET related AREL functions' do
  let!(:adapter) { ActiveRecord::Base.connection }
  before do
    adapter.create_table :ip_addresses, :force => true do |t|
      t.inet :address
    end

    class IpAddress < ActiveRecord::Base
      attr_accessible :address
    end
  end

  after do
    adapter.drop_table :ip_addresses
    Object.send(:remove_const, :IpAddress)
  end

  describe 'quoting IPAddr in sql statement' do
    it 'properly converts IPAddr to quoted strings when passed as an argument to a where clause' do
      IpAddress.where(:address => IPAddr.new('127.0.0.1')).to_sql.should include("'127.0.0.1/32'")
    end
  end

  describe 'cotained with (<<) operator' do
    it 'converts Arel contained_within statemnts to <<' do
      arel_table = IpAddress.arel_table

      arel_table.where(arel_table[:address].contained_within(IPAddr.new('127.0.0.1/24'))).to_sql.should match /<< '127.0.0.0\/24'/
    end
  end
end
