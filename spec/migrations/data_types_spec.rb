require 'spec_helper'

describe 'Native Data Types Migrations' do
  before do
    class Testing < ActiveRecord::Base; end
  end

  describe 'inet type' do
    it 'creates an inet column' do
      lambda do
        Testing.connection.create_table :data_types do |t|
          t.inet :ip_1
          t.inet :ip_2, :ip_3
        end
      end.should_not raise_exception

      columns = Testing.connection.columns(:data_types)
      ip_1 = columns.detect { |c| c.name == 'ip_1'}
      ip_2 = columns.detect { |c| c.name == 'ip_2'}
      ip_3 = columns.detect { |c| c.name == 'ip_3'}

      ip_1.sql_type.should eq 'inet'
      ip_2.sql_type.should eq 'inet'
      ip_3.sql_type.should eq 'inet'
    end
  end

  describe 'cidr type' do
    it 'creates an cidr column' do
      lambda do
        Testing.connection.create_table :data_types do |t|
          t.cidr :cidr_1
          t.cidr :cidr_2, :cidr_3
        end
      end.should_not raise_exception

      columns = Testing.connection.columns(:data_types)
      cidr_1 = columns.detect { |c| c.name == 'cidr_1'}
      cidr_2 = columns.detect { |c| c.name == 'cidr_2'}
      cidr_3 = columns.detect { |c| c.name == 'cidr_3'}

      cidr_1.sql_type.should eq 'cidr'
      cidr_2.sql_type.should eq 'cidr'
      cidr_3.sql_type.should eq 'cidr'
    end
  end

  describe 'macaddr type' do
    it 'creates an macaddr column' do
      lambda do
        Testing.connection.create_table :data_types do |t|
          t.macaddr :macaddr_1
          t.macaddr :macaddr_2, :macaddr_3
        end
      end.should_not raise_exception

      columns = Testing.connection.columns(:data_types)
      macaddr_1 = columns.detect { |c| c.name == 'macaddr_1'}
      macaddr_2 = columns.detect { |c| c.name == 'macaddr_2'}
      macaddr_3 = columns.detect { |c| c.name == 'macaddr_3'}

      macaddr_1.sql_type.should eq 'macaddr'
      macaddr_2.sql_type.should eq 'macaddr'
      macaddr_3.sql_type.should eq 'macaddr'
    end
  end

  after do
    Object.send(:remove_const, :Testing)
  end
end
