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
  let(:equality_regex) { %r{\"overlap_arel_arrays\"\.\"tags\" = '\{\"working\"\}'} }
  let(:overlap_regex)  { %r{\"overlap_arel_arrays\"\.\"tag_ids\" && '\{1,2\}'} }
  let(:any_regex)      { %r{2 = ANY\(\"overlap_arel_arrays\"\.\"tag_ids\"\)} }
  let(:all_regex)      { %r{2 = ALL\(\"overlap_arel_arrays\"\.\"tag_ids\"\)} }

  describe '.where(:array_column => [])' do
    it 'returns an array string instead of IN ()' do
      query = OverlapArelArray.where(:tags => ['working']).to_sql
      query.should match equality_regex
    end
  end

  describe '.where.overlap(:column => value)' do
    it 'generates the appropriate where clause' do
      query = OverlapArelArray.where.overlap(:tag_ids => [1,2])
      query.to_sql.should match overlap_regex
    end

    it 'allows chaining' do
      query = OverlapArelArray.where.overlap(:tag_ids => [1,2]).where(:tags => ['working']).to_sql

      query.should match overlap_regex
      query.should match equality_regex
    end
  end

  describe '.where.any(:column => value)' do
    it 'generates the appropriate where clause' do
      query = OverlapArelArray.where.any(:tag_ids => 2)
      query.to_sql.should match any_regex
    end

    it 'allows chaining' do
      query = OverlapArelArray.where.any(:tag_ids => 2).where(:tags => ['working']).to_sql

      query.should match any_regex
      query.should match equality_regex
    end
  end

  describe '.where.all(:column => value)' do
    it 'generates the appropriate where clause' do
      query = OverlapArelArray.where.all(:tag_ids => 2)
      query.to_sql.should match all_regex
    end

    it 'allows chaining' do
      query = OverlapArelArray.where.all(:tag_ids => 2).where(:tags => ['working']).to_sql

      query.should match all_regex
      query.should match equality_regex
    end
  end
end
