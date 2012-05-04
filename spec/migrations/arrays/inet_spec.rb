require 'spec_helper'

describe 'INET array migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  it 'creates an inet array column' do
    lambda do
      connection.create_table :data_types do |t|
        t.inet_array :inet_array_1
        t.inet_array :inet_array_2, :inet_array_3
        t.column :inet_array_4, :inet_array
      end
    end.should_not raise_exception

    columns = connection.columns(:data_types)
    inet_array_1 = columns.detect { |c| c.name == 'inet_array_1'}
    inet_array_2 = columns.detect { |c| c.name == 'inet_array_2'}
    inet_array_3 = columns.detect { |c| c.name == 'inet_array_3'}
    inet_array_4 = columns.detect { |c| c.name == 'inet_array_4'}

    inet_array_1.sql_type.should eq 'inet[]'
    inet_array_2.sql_type.should eq 'inet[]'
    inet_array_3.sql_type.should eq 'inet[]'
    inet_array_4.sql_type.should eq 'inet[]'
  end
end
