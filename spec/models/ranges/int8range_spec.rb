require 'spec_helper'

describe 'Models with int8range columns' do
  let!(:adapter) { ActiveRecord::Base.connection }

  context 'no default value, range' do
    before do
      adapter.create_table :int8_rangers, :force => true do |t|
        t.int8range :best_estimate
      end
      class Int8Ranger < ActiveRecord::Base
        attr_accessible :best_estimate
      end
    end

    after do
      adapter.drop_table :int8_rangers
      Object.send(:remove_const, :Int8Ranger)
    end

    describe '#create' do
      it 'creates an record when there is no assignment' do
        range = Int8Ranger.create()
        range.reload
        range.best_estimate.should eq nil
      end

      it 'creates an record with a range' do
        range = Int8Ranger.create( :best_estimate => 0..4)
        range.reload
        range.best_estimate.should eq 0...5
      end
    end

    describe 'range assignment' do
      it 'updates an record with an range string' do
        range = Int8Ranger.create( :best_estimate => 0..4)
        range.best_estimate = 0...9
        range.save

        range.reload
        range.best_estimate.should eq 0...9
      end

      it 'converts empty strings to nil' do
        range = Int8Ranger.create
        range.best_estimate = ''
        range.save

        range.reload
        range.best_estimate.should eq nil
      end
    end
  end

  context 'default value, int8 range' do
    before do
      adapter.create_table :int8_default_rangers, :force => true do |t|
        t.int8range :best_estimate, :default => 0..5
      end
      class Int8DefaultRanger < ActiveRecord::Base
        attr_accessible :best_estimate
      end
    end

    after do
      adapter.drop_table :int8_default_rangers
      Object.send(:remove_const, :Int8DefaultRanger)
    end

    describe '#create' do
      it 'creates an record when there is no assignment' do
        range = Int8DefaultRanger.create()
        range.reload
        range.best_estimate.should eq 0...6
      end

      it 'creates an record with a range' do
        range = Int8DefaultRanger.create( :best_estimate => 0..4)
        range.reload
        range.best_estimate.should eq 0...5
      end
    end
  end
end
