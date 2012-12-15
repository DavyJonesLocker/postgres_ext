require 'spec_helper'

describe 'index migrations' do
  let!(:connection) { ActiveRecord::Base.connection }
  after { connection.drop_table :index_types }
  it 'creates special index' do
    lambda do
      connection.create_table :index_types do |t|
        t.integer :col1, :array => true
        t.integer :col2
        t.text    :col3
      end
      connection.add_index(:index_types, :col1, :index_type => :gin)
      connection.add_index(:index_types, :col2, :where => '(col2 > 50)')
      connection.add_index(:index_types, :col3, :index_type => :gin, :index_opclass => :gin_trgm_ops)
    end.should_not raise_exception

    indexes = connection.indexes(:index_types)
    index_1 = indexes.detect { |c| c.columns.map(&:to_s) == ['col1']}
    index_2 = indexes.detect { |c| c.columns.map(&:to_s) == ['col2']}
    index_3 = indexes.detect { |c| c.columns.map(&:to_s) == ['col3']}

    index_1.index_type.to_s.should  eq    'gin'
    index_2.where.should            match /col2 > 50/
    index_3.index_type.should       eq    :gin
    index_3.index_opclass.should    eq    :gin_trgm_ops
  end
end
