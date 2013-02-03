require 'spec_helper'

describe 'where array clauses' do
  let!(:adapter) { ActiveRecord::Base.connection }

  before do
    adapter.create_table :overlap_arel_arrays, :force => true do |t|
      t.string :tags, :array => true
      t.integer :tag_ids, :array => true
    end

    class OverlapArelArray < ActiveRecord::Base
      attr_accessible :tags, :tags_ids
    end
  end
  after do
    adapter.drop_table :overlap_arel_arrays
  end
  describe '.where(:array_column => [])' do
    it 'returns an array string instead of IN ()' do
      query = OverlapArelArray.where(:tags => ['working']).to_sql
      query.should match /\"overlap_arel_arrays\"\.\"tags\" = '\{\"working\"\}'/
    end
  end

  describe '.where.overlap(:column => value)' do
    it 'generates the appropriate where clause' do
      query = OverlapArelArray.where.overlap(:tag_ids => [1,2])
      query.to_sql.should match /\"overlap_arel_arrays\"\.\"tag_ids\" && '\{1,2\}'/
    end

    it 'allows chaining' do
      query = OverlapArelArray.where.overlap(:tag_ids => [1,2]).where(:tags => ['working']).to_sql

      query.should match /\"overlap_arel_arrays\"\.\"tag_ids\" && '\{1,2\}'/
      query.should match /\"overlap_arel_arrays\"\.\"tags\" = '\{\"working\"\}'/
    end
  end
end
