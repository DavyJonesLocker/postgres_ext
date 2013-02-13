require 'spec_helper'

describe 'CITEXT migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  before(:all) { ActiveRecord::Base.connection.add_extension('citext') if ActiveRecord::Base.connection.supports_extensions? }
  after { connection.drop_table :data_types }
  it 'creates an citext column' do
    lambda do
      connection.create_table :data_types do |t|
        t.citext :citext_1
        t.citext :citext_2, :citext_3
        t.column :citext_4, :citext
        t.text   :citext_5
      end

      connection.change_column :data_types, :citext_5, :citext
    end.should_not raise_exception

    columns = connection.columns(:data_types)
    citext_1 = columns.detect { |c| c.name == 'citext_1'}
    citext_2 = columns.detect { |c| c.name == 'citext_2'}
    citext_3 = columns.detect { |c| c.name == 'citext_3'}
    citext_4 = columns.detect { |c| c.name == 'citext_4'}
    citext_5 = columns.detect { |c| c.name == 'citext_5'}

    citext_1.sql_type.should eq 'citext'
    citext_2.sql_type.should eq 'citext'
    citext_3.sql_type.should eq 'citext'
    citext_4.sql_type.should eq 'citext'
    citext_5.sql_type.should eq 'citext'
  end
end
