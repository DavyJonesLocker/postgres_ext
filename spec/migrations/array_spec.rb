require 'spec_helper'

describe 'Array migrations' do
  let!(:connection) { ActiveRecord::Base.connection }

  context 'New Table' do
    after { connection.drop_table :data_types }
    describe 'Create table methods' do
      it 'creates an array column' do
        lambda do
          connection.create_table :data_types do |t|
            t.cidr :array_1, :array => true
            t.cidr :array_2, :array_3, :array => true
            t.column :array_4, :cidr, :array => true
          end
        end.should_not raise_exception

        columns = connection.columns(:data_types)

        array_1 = columns.detect { |c| c.name == 'array_1'}
        array_2 = columns.detect { |c| c.name == 'array_2'}
        array_3 = columns.detect { |c| c.name == 'array_3'}
        array_4 = columns.detect { |c| c.name == 'array_4'}

        array_1.sql_type.should eq 'cidr[]'
        array_2.sql_type.should eq 'cidr[]'
        array_3.sql_type.should eq 'cidr[]'
        array_4.sql_type.should eq 'cidr[]'
      end
    end
  end

  context 'Existing Table' do
    before { connection.create_table :data_types }
    after  { connection.drop_table   :data_types }
    describe 'Add Column' do
      it 'creates an array column' do
        lambda do
          connection.add_column :data_types, :array_5, :cidr, :array => true
        end.should_not raise_exception

        columns = connection.columns(:data_types)

        array_5 = columns.detect { |c| c.name == 'array_5'}
        array_5.sql_type.should eq 'cidr[]'
      end
    end

    describe 'Change table methods' do
      it 'creates an array column' do
        lambda do
          connection.change_table :data_types do |t|
            t.column :array_6, :cidr, :array => true
            t.cidr :array_7, :array => true
          end
        end.should_not raise_exception

        columns = connection.columns(:data_types)

        array_6 = columns.detect { |c| c.name == 'array_6'}
        array_7 = columns.detect { |c| c.name == 'array_7'}

        array_6.sql_type.should eq 'cidr[]'
        array_7.sql_type.should eq 'cidr[]'
      end
    end
  end

  context 'Default Values' do
    describe 'String defaults' do
      after { connection.drop_table :default_strings }
      it 'creates array column with proper defaults' do
        lambda do
          connection.create_table :default_strings do |t|
            t.string :names_1, :array => true, :default => []
            t.string :names_2, :array => true, :default => '{}'
            t.string :names_3, :array => true, :default => ['something']
            t.string :names_4, :array => true, :default => '{something}'
          end
        end.should_not raise_exception
        columns = connection.columns(:default_strings)

        names_1 = columns.detect { |c| c.name == 'names_1' }
        names_2 = columns.detect { |c| c.name == 'names_2' }
        names_3 = columns.detect { |c| c.name == 'names_3' }
        names_4 = columns.detect { |c| c.name == 'names_4' }

        names_1.default.should eq []
        names_2.default.should eq []
        names_3.default.should eq ['something']
        names_4.default.should eq ['something']
      end
    end

    describe 'Integer defaults' do
      after { connection.drop_table :default_integers }
      it 'creates array column with proper defaults' do
        lambda do
          connection.create_table :default_integers do |t|
            t.integer :numbers_1, :array => true, :default => []
            t.integer :numbers_2, :array => true, :default => '{}'
            t.integer :numbers_3, :array => true, :default => [3]
            t.integer :numbers_4, :array => true, :default => '{4}'
          end
        end.should_not raise_exception
        columns = connection.columns(:default_integers)

        numbers_1 = columns.detect { |c| c.name == 'numbers_1' }
        numbers_2 = columns.detect { |c| c.name == 'numbers_2' }
        numbers_3 = columns.detect { |c| c.name == 'numbers_3' }
        numbers_4 = columns.detect { |c| c.name == 'numbers_4' }

        numbers_1.default.should eq []
        numbers_2.default.should eq []
        numbers_3.default.should eq [3]
        numbers_4.default.should eq [4]
      end
    end
  end
end
