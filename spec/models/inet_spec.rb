require 'spec_helper'

describe 'Models with integer range columns' do
  let!(:adapter) { ActiveRecord::Base.connection }

  context 'no default value, range' do
    before do
      adapter.create_table :rangers, :force => true do |t|
        t.integer_range :best_estimate
      end
      class Ranger < ActiveRecord::Base
        attr_accessible :best_estimate
      end
    end

    after do
      adapter.drop_table :rangers
      Object.send(:remove_const, :Ranger)
    end

    describe '#create' do
      it 'creates an record when there is no assignment' do
        range = Ranger.create()
        range.reload
        range.best_estimate.should eq nil
      end

      it 'creates an record with a range' do
        range = Ranger.create( :best_estimate => 0..4)
        range.reload
        range.best_estimate.should eq 0..4
      end
    end

    describe 'range assignment' do
      it 'updates an record with an range string' do
        range = Ranger.create( :best_estimate => 0..4)
        range.best_estimate = 0...9
        range.save

        range.reload
        range.best_estimate.should eq 0...9
      end

      it 'converts empty strings to nil' do
        range = Ranger.create
        range.best_estimate = ''
        range.save

        range.reload
        range.best_estimate.should eq nil
      end
    end
  end
  context 'default value, integer range' do
    before do
      adapter.create_table :default_rangers, :force => true do |t|
        t.integer_range :best_estimate, :default => 0..5
      end
      class DefaultRanger < ActiveRecord::Base
        attr_accessible :best_estimate
      end
    end

    after do
      adapter.drop_table :default_rangers
      Object.send(:remove_const, :DefaultRanger)
    end
    describe '#create' do
      it 'creates an record when there is no assignment' do
        range = DefaultRanger.create()
        range.reload
        range.best_estimate.should eq 0..5
      end

      it 'creates an record with a range' do
        range = DefaultRanger.create( :best_estimate => 0..4)
        range.reload
        range.best_estimate.should eq 0..4
      end
    end
  end
end
