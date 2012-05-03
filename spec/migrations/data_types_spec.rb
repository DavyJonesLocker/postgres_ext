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

  describe 'Array types' do
    describe 'Integer array types' do
      it 'creates an macaddr column' do
        lambda do
          Testing.connection.create_table :data_types do |t|
            t.integer_array :int_array_1
            t.integer_array :int_array_2, :int_array_3
          end
        end.should_not raise_exception

        columns = Testing.connection.columns(:data_types)
        int_array_1 = columns.detect { |c| c.name == 'int_array_1'}
        int_array_2 = columns.detect { |c| c.name == 'int_array_2'}
        int_array_3 = columns.detect { |c| c.name == 'int_array_3'}

        int_array_1.sql_type.should eq 'integer[]'
        int_array_2.sql_type.should eq 'integer[]'
        int_array_3.sql_type.should eq 'integer[]'
      end

      it 'adhears to the limit option' do
        lambda do
          Testing.connection.create_table :data_types do |t|
            t.integer_array :one_int_array, :limit => 1
            t.integer_array :four_int_array, :limit => 4
            t.integer_array :eight_int_array, :limit => 8
            t.integer_array :eleven_int_array, :limit => 11
          end
        end.should_not raise_exception
        columns = Testing.connection.columns(:data_types)
        one    = columns.detect { |c| c.name == 'one_int_array'}
        four   = columns.detect { |c| c.name == 'four_int_array'}
        eight  = columns.detect { |c| c.name == 'eight_int_array'}
        eleven = columns.detect { |c| c.name == 'eleven_int_array'}

        one.sql_type.should eq 'smallint[]'
        four.sql_type.should eq 'integer[]'
        eight.sql_type.should eq 'bigint[]'
        eleven.sql_type.should eq 'integer[]'
      end
    end
  end

  after do
    Object.send(:remove_const, :Testing)
  end
end
