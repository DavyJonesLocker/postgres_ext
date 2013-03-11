require 'spec_helper'

describe 'Array Column Predicates' do
  describe 'Array Overlap' do
    it 'converts Arel overlap statment' do
      arel_table = Person.arel_table

      arel_table.where(arel_table[:tags].overlap(['tag','tag 2'])).to_sql.should match /&& '\{"tag","tag 2"\}'/
    end

    it 'converts Arel overlap statment' do
      arel_table = Person.arel_table

      arel_table.where(arel_table[:tag_ids].overlap([1,2])).to_sql.should match /&& '\{1,2\}'/
    end

    it 'works with count (and other predicates)' do
      arel_table = Person.arel_table

      Person.where(arel_table[:tag_ids].overlap([1,2])).count.should eq 0
    end

    it 'returns matched records' do
      one = Person.create!(:tags => ['one'])
      two = Person.create!(:tags => ['two'])
      arel_table = Person.arel_table

      query = arel_table.where(arel_table[:tags].overlap(['one'])).project(Arel.sql('*'))
      Person.find_by_sql(query.to_sql).should include(one)

      query = arel_table.where(arel_table[:tags].overlap(['two'])).project(Arel.sql('*'))
      Person.find_by_sql(query.to_sql).should include(two)

      query = arel_table.where(arel_table[:tags].overlap(['two','one'])).project(Arel.sql('*'))
      Person.find_by_sql(query.to_sql).should include(two)
      Person.find_by_sql(query.to_sql).should include(one)
    end
  end

  describe 'Array Contains' do
    it 'converts Arel array_contains statement and escapes strings' do
      arel_table = Person.arel_table

      arel_table.where(arel_table[:tags].array_contains(['tag','tag 2'])).to_sql.should match /@> '\{"tag","tag 2"\}'/
    end

    it 'converts Arel array_contains statement with numbers' do
      arel_table = Person.arel_table

      arel_table.where(arel_table[:tag_ids].array_contains([1,2])).to_sql.should match /@> '\{1,2\}'/
    end

    it 'works with count (and other predicates)' do
      arel_table = Person.arel_table

      Person.where(arel_table[:tag_ids].array_contains([1,2])).count.should eq 0
    end

    it 'returns matched records' do
      one = Person.create!(:tags => ['one', 'two', 'three'])
      two = Person.create!(:tags => ['one', 'three'])
      arel_table = Person.arel_table

      query = arel_table.where(arel_table[:tags].array_contains(['one', 'two'])).project(Arel.sql('*'))
      Person.find_by_sql(query.to_sql).should include one
      Person.find_by_sql(query.to_sql).should_not include two

      query = arel_table.where(arel_table[:tags].array_contains(['one', 'three'])).project(Arel.sql('*'))
      Person.find_by_sql(query.to_sql).should include one
      Person.find_by_sql(query.to_sql).should include two

      query = arel_table.where(arel_table[:tags].array_contains(['two'])).project(Arel.sql('*'))
      Person.find_by_sql(query.to_sql).should include one
      Person.find_by_sql(query.to_sql).should_not include two
    end
  end
end
