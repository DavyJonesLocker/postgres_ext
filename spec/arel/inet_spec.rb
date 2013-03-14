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

  describe "arel node operators",:wip => true do
    it "ContainedWithin" do
      Arel::Nodes::ContainedWithin.new(nil,nil).operator.should == :<<
    end
    it "ContainedWithinEquals" do
      Arel::Nodes::ContainedWithinEquals.new(nil,nil).operator.should == '<<='.to_sym
    end
    it "ContainedWithinEquals" do
      Arel::Nodes::Contains.new(nil,nil).operator.should == :>>
    end
    it "ContainedWithinEquals" do
      Arel::Nodes::ContainsEquals.new(nil,nil).operator.should == '>>='.to_sym
    end
  end

  describe 'quoting IPAddr in sql statement' do
    it 'properly converts IPAddr to quoted strings when passed as an argument to a where clause' do
      IpAddress.where(:address => IPAddr.new('127.0.0.1')).to_sql.should include("'127.0.0.1/32'")
    end
  end

  describe 'contained with (<<) operator' do
    it 'converts Arel contained_within statements to <<' do
      arel_table = IpAddress.arel_table

      arel_table.where(arel_table[:address].contained_within(IPAddr.new('127.0.0.1/24'))).to_sql.should match /<< '127.0.0.0\/24'/
    end
  end

  describe 'contained within or equals (<<=) operator' do
    it 'converts Arel contained_within_or_equals statements to  <<=' do
      arel_table  = IpAddress.arel_table

      arel_table.where(arel_table[:address].contained_within_or_equals(IPAddr.new('127.0.0.1/24'))).to_sql.should match /<<= '127.0.0.0\/24'/
    end
  end
  describe 'contains (>>) operator' do
    it 'converts Arel contains statements to >>' do
      arel_table = IpAddress.arel_table

      arel_table.where(arel_table[:address].contains(IPAddr.new('127.0.0.1/24'))).to_sql.should match />> '127.0.0.0\/24'/
    end
  end

  describe 'contains or equals (>>=) operator' do
    it 'converts Arel contains_or_equals statements to  >>=' do
      arel_table  = IpAddress.arel_table

      arel_table.where(arel_table[:address].contains_or_equals(IPAddr.new('127.0.0.1/24'))).to_sql.should match />>= '127.0.0.0\/24'/
    end
  end
end
