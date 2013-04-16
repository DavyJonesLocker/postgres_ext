require 'spec_helper'

describe 'ean13 migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  before(:all) { ActiveRecord::Base.connection.add_extension('isn') if ActiveRecord::Base.connection.supports_extensions? }
  after { connection.drop_table :data_types }
  it 'creates an ean13 column' do
    lambda do
      connection.create_table :data_types do |t|
        t.ean13 :ean13_1
        t.ean13 :ean13_2, :ean13_3
        t.column :ean13_4, :ean13
      end
    end.should_not raise_exception

    columns = connection.columns(:data_types)
    ean13_1 = columns.detect { |c| c.name == 'ean13_1'}
    ean13_2 = columns.detect { |c| c.name == 'ean13_2'}
    ean13_3 = columns.detect { |c| c.name == 'ean13_3'}
    ean13_4 = columns.detect { |c| c.name == 'ean13_4'}

    ean13_1.sql_type.should eq 'ean13'
    ean13_2.sql_type.should eq 'ean13'
    ean13_3.sql_type.should eq 'ean13'
    ean13_4.sql_type.should eq 'ean13'
  end
end
