require 'spec_helper'

describe 'MACADDR migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :data_types }
  it 'creates an macaddr column' do
    lambda do
      connection.create_table :data_types do |t|
        t.macaddr :macaddr_1
        t.macaddr :macaddr_2, :macaddr_3
        t.column :macaddr_4, :macaddr
      end
    end.should_not raise_exception

    columns = connection.columns(:data_types)
    macaddr_1 = columns.detect { |c| c.name == 'macaddr_1'}
    macaddr_2 = columns.detect { |c| c.name == 'macaddr_2'}
    macaddr_3 = columns.detect { |c| c.name == 'macaddr_3'}
    macaddr_4 = columns.detect { |c| c.name == 'macaddr_4'}

    macaddr_1.sql_type.should eq 'macaddr'
    macaddr_2.sql_type.should eq 'macaddr'
    macaddr_3.sql_type.should eq 'macaddr'
    macaddr_4.sql_type.should eq 'macaddr'
  end
end
