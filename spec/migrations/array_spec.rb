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
end
