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
      context 'no default' do
        it 'creates an array column' do
          lambda do
            connection.add_column :data_types, :array_5, :cidr, :array => true
          end.should_not raise_exception

          columns = connection.columns(:data_types)

          array_5 = columns.detect { |c| c.name == 'array_5'}
          array_5.sql_type.should eq 'cidr[]'
        end
      end

      context 'with default' do
        it 'creates an array column' do
          lambda do
            connection.add_column :data_types, :array_6, :integer, :array => true, :default => []
          end.should_not raise_exception

          columns = connection.columns(:data_types)

          array_6 = columns.detect { |c| c.name == 'array_6'}
          array_6.sql_type.should eq 'integer[]'
        end
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

  context 'Change Column' do
    describe 'Change with column existing as array' do
      after { connection.drop_table :data_types }
      it 'updates the column definitions' do
        lambda do
          connection.create_table :data_types do |t|
            t.integer :array_1, :array => true, :default => []
          end

          connection.change_column :data_types, :array_1, :integer, :array => true, :default => [], :null => false
        end.should_not raise_exception

        columns = connection.columns(:data_types)

        array_1 = columns.detect { |c| c.name == 'array_1'}
        array_1.sql_type.should eq 'integer[]'
        array_1.default.should  eq []
        array_1.null.should     be_false
      end
    end

    describe 'Change string column to array' do
      after { connection.drop_table :data_types }
      it 'updates the column definitions' do
        lambda do
          connection.create_table :data_types do |t|
            t.string :string_1
          end

          connection.exec_query "INSERT INTO data_types (string_1) VALUES ('some,values,here')"
          connection.change_column :data_types, :string_1, :string, :array => true, :default => [], :null => false
        end.should_not raise_exception

        columns = connection.columns(:data_types)

        string_1 = columns.detect { |c| c.name == 'string_1'}
        string_1.sql_type.should eq 'character varying(255)[]'
        string_1.default.should  eq []
        string_1.null.should     be_false

        new_string_value = connection.exec_query "SELECT array_length(string_1, 1) FROM data_types LIMIT 1"
        if RUBY_PLATFORM =~ /java/
          new_string_value.first['array_length'].should eq 3
        else
          new_string_value.rows.first.should == ['3']
        end
      end
    end

    describe 'Change text column to array' do
      after { connection.drop_table :data_types }
      it 'updates the column definitions' do
        lambda do
          connection.create_table :data_types do |t|
            t.text :text_1
          end

          connection.exec_query "INSERT INTO data_types (text_1) VALUES ('some,values,here')"
          connection.change_column :data_types, :text_1, :text, :array => true, :default => [], :null => false
        end.should_not raise_exception

        columns = connection.columns(:data_types)

        text_1 = columns.detect { |c| c.name == 'text_1'}
        text_1.sql_type.should eq 'text[]'
        text_1.default.should  eq []
        text_1.null.should     be_false

        new_text_value = connection.exec_query "SELECT array_length(text_1, 1) FROM data_types LIMIT 1"
        if RUBY_PLATFORM =~ /java/
          new_text_value.first['array_length'].should eq 3
        else
          new_text_value.rows.first.should eq ['3']
        end
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
