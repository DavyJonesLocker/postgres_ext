require 'spec_helper'

describe 'INET migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :data_types }
  it 'creates an inet column' do
    lambda do
      connection.create_table :data_types do |t|
        t.inet :ip_1
        t.inet :ip_2, :ip_3
        t.column :ip_4, :inet
      end
    end.should_not raise_exception

    columns = connection.columns(:data_types)
    ip_1 = columns.detect { |c| c.name == 'ip_1'}
    ip_2 = columns.detect { |c| c.name == 'ip_2'}
    ip_3 = columns.detect { |c| c.name == 'ip_3'}
    ip_4 = columns.detect { |c| c.name == 'ip_4'}

    ip_1.sql_type.should eq 'inet'
    ip_2.sql_type.should eq 'inet'
    ip_3.sql_type.should eq 'inet'
    ip_4.sql_type.should eq 'inet'
  end
end
