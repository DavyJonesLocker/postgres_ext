require 'spec_helper'

describe 'Array Column Predicates' do
  let!(:adapter) { ActiveRecord::Base.connection }

  before do
    adapter.create_table :arel_arrays, :force => true do |t|
      t.string :tags, :array => true
    end

    class ArelArray < ActiveRecord::Base
      attr_accessible :tags
    end
  end

  after do
    adapter.drop_table :arel_arrays
    Object.send(:remove_const, :ArelArray)
  end

  describe 'Array Any' do
    it 'converts Arel array_any_eq statement' do
      arel_table = ArelArray.arel_table

      arel_table.where(arel_table[:tags].array_any_eq('my tag')).to_sql.should match /'my tag' = ANY\("arel_arrays"\."tags"\)/
    end

    it 'returns matched records' do
      one = ArelArray.create!(:tags => ['one'])
      two = ArelArray.create!(:tags => ['two'])
      arel_table = ArelArray.arel_table

      ArelArray.where(arel_table[:tags].array_any_eq('one')).should include(one)
    end
  end
end
