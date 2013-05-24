require 'spec_helper'

describe 'Models with tsrange columns' do
  let!(:adapter) { ActiveRecord::Base.connection }

  context 'no default value, range' do
    before do
      adapter.create_table :ts_rangers, :force => true do |t|
        t.tsrange :best_estimate
      end
      class TsRanger < ActiveRecord::Base
        attr_accessible :best_estimate
      end
    end

    after do
      adapter.drop_table :ts_rangers
      Object.send(:remove_const, :TsRanger)
    end

    describe '#create' do
      it 'creates an record when there is no assignment' do
        range = TsRanger.create()
        range.reload
        range.best_estimate.should eq nil
      end

      it 'creates an record with a range' do
        ts_range = Time.new(2011, 01, 01, 12, 34)..Time.new(2012, 01, 31, 8, 0, 1)
        range = TsRanger.create( :best_estimate => ts_range)
        range.reload
        range.best_estimate.should eq ts_range
      end
    end

    describe 'range assignment' do
      it 'updates an record with an range string' do
        ts_range = Time.new(2011, 01, 01, 12, 34)..Time.new(2012, 01, 31, 8, 0, 1)
        new_ts_range = Time.new(2012, 01, 01, 11, 0, 0)..Time.new(2012, 02, 01, 13, 0, 0)
        range = TsRanger.create( :best_estimate => ts_range)
        range.best_estimate = new_ts_range
        range.save

        range.reload
        range.best_estimate.should eq new_ts_range
      end

      it 'converdate empty strings to nil' do
        range = TsRanger.create
        range.best_estimate = ''
        range.save

        range.reload
        range.best_estimate.should eq nil
      end
    end
  end

  context 'default value, ts range' do
    before do
      adapter.create_table :ts_default_rangers, :force => true do |t|
        t.tsrange :best_estimate, :default => Time.new(2011, 01, 01, 12, 34)..Time.new(2011, 01, 31, 1, 0)
      end
      class TsDefaultRanger < ActiveRecord::Base
        attr_accessible :best_estimate
      end
    end

    after do
      adapter.drop_table :ts_default_rangers
      Object.send(:remove_const, :TsDefaultRanger)
    end

    describe '#create' do
      it 'creates an record when there is no assignment' do
        range = TsDefaultRanger.create()
        range.reload
        range.best_estimate.should eq Time.new(2011, 01, 01, 12, 34)..Time.new(2011, 01, 31, 1, 0)
      end

      it 'creates an record with a range' do
        new_ts_range = Time.new(2012, 01, 01, 9, 0, 0)..Time.new(2012, 12, 31, 9, 0, 0)
        range = TsDefaultRanger.create(:best_estimate => new_ts_range)
        range.reload
        range.best_estimate.should eq new_ts_range
      end
    end
  end
end
