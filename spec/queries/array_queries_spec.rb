require 'spec_helper'

describe 'Array queries' do
  let(:equality_regex) { %r{\"people\"\.\"tags\" = '\{\"working\"\}'} }
  let(:overlap_regex)  { %r{\"people\"\.\"tag_ids\" && '\{1,2\}'} }
  let(:contains_regex) { %r{\"people\"\.\"tag_ids\" @> '\{1,2\}'} }
  let(:any_regex)      { %r{2 = ANY\(\"people\"\.\"tag_ids\"\)} }
  let(:all_regex)      { %r{2 = ALL\(\"people\"\.\"tag_ids\"\)} }

  describe '.where(:array_column => [])' do
    it 'returns an array string instead of IN ()' do
      query = Person.where(:tags => ['working']).to_sql
      query.should match equality_regex
    end
  end

  describe '.where.overlap(:column => value)' do
    it 'generates the appropriate where clause' do
      query = Person.where.overlap(:tag_ids => [1,2])
      query.to_sql.should match overlap_regex
    end

    it 'allows chaining' do
      query = Person.where.overlap(:tag_ids => [1,2]).where(:tags => ['working']).to_sql

      query.should match overlap_regex
      query.should match equality_regex
    end
  end

  describe '.where.array_contains(:column => value)' do
    it 'generates the appropriate where clause' do
      query = Person.where.array_contains(:tag_ids => [1,2])
      query.to_sql.should match contains_regex
    end

    it 'allows chaining' do
      query = Person.where.array_contains(:tag_ids => [1,2]).where(:tags => ['working']).to_sql

      query.should match contains_regex
      query.should match equality_regex
    end
  end

  describe '.where.any(:column => value)' do
    it 'generates the appropriate where clause' do
      query = Person.where.any(:tag_ids => 2)
      query.to_sql.should match any_regex
    end

    it 'allows chaining' do
      query = Person.where.any(:tag_ids => 2).where(:tags => ['working']).to_sql

      query.should match any_regex
      query.should match equality_regex
    end
  end

  describe '.where.all(:column => value)' do
    it 'generates the appropriate where clause' do
      query = Person.where.all(:tag_ids => 2)
      query.to_sql.should match all_regex
    end

    it 'allows chaining' do
      query = Person.where.all(:tag_ids => 2).where(:tags => ['working']).to_sql

      query.should match all_regex
      query.should match equality_regex
    end
  end
end
