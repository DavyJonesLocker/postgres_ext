require 'spec_helper'

describe 'Array Column Predicates' do
  let!(:adapter) { ActiveRecord::Base.connection }

  before do
    adapter.create_table :arel_arrays, :force => true do |t|
      t.string :tags, :array => true
      t.integer :tag_ids, :array => true
    end

    class ArelArray < ActiveRecord::Base
      attr_accessible :tags
    end
  end

  after do
    adapter.drop_table :arel_arrays
    Object.send(:remove_const, :ArelArray)
  end

  describe 'Array Overlap' do
    it 'converts Arel array_overlap statment' do
      arel_table = ArelArray.arel_table

      arel_table.where(arel_table[:tags].array_overlap(['tag','tag 2'])).to_sql.should match /&& '\{"tag","tag 2"\}'/
    end

    it 'converts Arel array_overlap statment' do
      arel_table = ArelArray.arel_table

      arel_table.where(arel_table[:tag_ids].array_overlap([1,2])).to_sql.should match /&& '\{1,2\}'/
    end

    it 'works with count (and other predicates)' do
      arel_table = ArelArray.arel_table

      ArelArray.where(arel_table[:tag_ids].array_overlap([1,2])).count.should eq 0
    end

    it 'returns matched records' do
      one = ArelArray.create!(:tags => ['one'])
      two = ArelArray.create!(:tags => ['two'])
      arel_table = ArelArray.arel_table

      query = arel_table.where(arel_table[:tags].array_overlap(['one'])).project(Arel.sql('*'))
      ArelArray.find_by_sql(query.to_sql).should include(one)

      query = arel_table.where(arel_table[:tags].array_overlap(['two'])).project(Arel.sql('*'))
      ArelArray.find_by_sql(query.to_sql).should include(two)

      query = arel_table.where(arel_table[:tags].array_overlap(['two','one'])).project(Arel.sql('*'))
      ArelArray.find_by_sql(query.to_sql).should include(two)
      ArelArray.find_by_sql(query.to_sql).should include(one)
    end
  end

  describe 'Array Contains' do
    it 'converts Arel array_contains statement and escapes strings' do
      arel_table = ArelArray.arel_table

      arel_table.where(arel_table[:tags].array_contains(['tag','tag 2'])).to_sql.should match /@> '\{"tag","tag 2"\}'/
    end

    it 'converts Arel array_contains statement with numbers' do
      arel_table = ArelArray.arel_table

      arel_table.where(arel_table[:tag_ids].array_contains([1,2])).to_sql.should match /@> '\{1,2\}'/
    end

    it 'works with count (and other predicates)' do
      arel_table = ArelArray.arel_table

      ArelArray.where(arel_table[:tag_ids].array_contains([1,2])).count.should eq 0
    end

    it 'returns matched records' do
      one = ArelArray.create!(:tags => ['one', 'two', 'three'])
      two = ArelArray.create!(:tags => ['one', 'three'])
      arel_table = ArelArray.arel_table

      query = arel_table.where(arel_table[:tags].array_contains(['one', 'two'])).project(Arel.sql('*'))
      ArelArray.find_by_sql(query.to_sql).should include one
      ArelArray.find_by_sql(query.to_sql).should_not include two

      query = arel_table.where(arel_table[:tags].array_contains(['one', 'three'])).project(Arel.sql('*'))
      ArelArray.find_by_sql(query.to_sql).should include one
      ArelArray.find_by_sql(query.to_sql).should include two

      query = arel_table.where(arel_table[:tags].array_contains(['two'])).project(Arel.sql('*'))
      ArelArray.find_by_sql(query.to_sql).should include one
      ArelArray.find_by_sql(query.to_sql).should_not include two
    end
  end
end
