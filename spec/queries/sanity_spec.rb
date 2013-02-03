require 'spec_helper'

describe 'Ensure that we don\'t stomp on Active Record\'s queries' do
  let!(:adapter) { ActiveRecord::Base.connection }

  before do
    adapter.create_table :sanity_tests, :force => true do |t|
      t.string :tags, :array => true
      t.integer :tag_ids, :array => true
    end

    class SanityTest < ActiveRecord::Base
      attr_accessible :tags, :tags_ids
    end
  end
  describe '.where' do
    it 'generates IN clauses for non array columns' do
      query = SanityTest.where(:id => [1,2,3]).to_sql

      query.should match /IN \(1, 2, 3\)/
    end
  end
end
