require 'spec_helper'

describe 'Contains queries' do
  let(:contained_within_regex)        { %r{\"people\"\.\"ip\" << '127.0.0.1/24'} }
  let(:contained_within_equals_regex) { %r{\"people\"\.\"ip\" <<= '127.0.0.1/24'} }
  let(:contains_regex)                { %r{\"people\"\.\"ip\" >> '127.0.0.1'} }
  let(:contains_equals_regex)         { %r{\"people\"\.\"ip\" >>= '127.0.0.1'} }

  describe '.where.contained_within(:column, value)' do
    it 'generates the appropriate where clause' do
      query = Person.where.contained_within(:ip => '127.0.0.1/24')
      query.to_sql.should match contained_within_regex
    end
  end

  describe '.where.contained_within_or_equals(:column, value)' do
    it 'generates the appropriate where clause' do
      query = Person.where.contained_within_or_equals(:ip => '127.0.0.1/24')
      query.to_sql.should match contained_within_equals_regex
    end
  end

  describe '.where.contains(:column, value)' do
    it 'generates the appropriate where clause' do
      query = Person.where.contains(:ip => '127.0.0.1')
      query.to_sql.should match contains_regex
    end
  end

  describe '.where.contained_within_or_equals(:column, value)' do
    it 'generates the appropriate where clause' do
      query = Person.where.contains_or_equals(:ip => '127.0.0.1')
      query.to_sql.should match contains_equals_regex
    end
  end
end
