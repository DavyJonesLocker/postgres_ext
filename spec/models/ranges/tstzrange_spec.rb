require 'spec_helper'

describe 'Models with tstzrange columns' do
  let!(:adapter) { ActiveRecord::Base.connection }

  context 'no default value, range' do
    before do
      adapter.create_table :tstz_rangers, :force => true do |t|
        t.tstzrange :best_estimate
      end
      class TstzRanger < ActiveRecord::Base
        attr_accessible :best_estimate
      end
    end

    after do
      adapter.drop_table :tstz_rangers
      Object.send(:remove_const, :TstzRanger)
    end

    describe '#create' do
      it 'creates an record when there is no assignment' do
        range = TstzRanger.create()
        range.reload
        range.best_estimate.should eq nil
      end

      it 'creates an record with a range' do
        ts_range = Time.new(2011, 01, 01, 12, 34)..Time.new(2012, 01, 31, 8, 0, 1)
        range = TstzRanger.create( :best_estimate => ts_range)
        range.reload
        range.best_estimate.should eq ts_range
      end
    end

    describe 'range assignment' do
      it 'updates an record with an range string' do
        ts_range = Time.new(2011, 01, 01, 12, 34)..Time.new(2012, 01, 31, 8, 0, 1)
        new_ts_range = Time.new(2012, 01, 01, 11, 0, 0)..Time.new(2012, 02, 01, 13, 0, 0)
        range = TstzRanger.create( :best_estimate => ts_range)
        range.best_estimate = new_ts_range
        range.save

        range.reload
        range.best_estimate.should eq new_ts_range
      end

      it 'converdate empty strings to nil' do
        range = TstzRanger.create
        range.best_estimate = ''
        range.save

        range.reload
        range.best_estimate.should eq nil
      end
    end
  end

  context 'default value, ts range' do
    before do
      adapter.create_table :tstz_default_rangers, :force => true do |t|
        t.tstzrange :best_estimate, :default => Time.new(2011, 01, 01, 12, 34, 0, '-07:00')..Time.new(2011, 01, 31, 1, 0, 0, '-07:00')
      end
      class TstzDefaultRanger < ActiveRecord::Base
        attr_accessible :best_estimate
      end
    end

    after do
      adapter.drop_table :tstz_default_rangers
      Object.send(:remove_const, :TstzDefaultRanger)
    end

    describe '#create' do
      it 'creates an record when there is no assignment' do
        range = TstzDefaultRanger.create()
        range.reload
        range.best_estimate.should eq Time.new(2011, 01, 01, 12, 34,0, '-07:00')..Time.new(2011, 01, 31, 1, 0, 0, '-07:00')
      end

      it 'creates an record with a range' do
        new_ts_range = Time.new(2012, 01, 01, 9, 0, 0, '-05:00')..Time.new(2012, 12, 31, 9, 0, 0, '-05:00')
        range = TstzDefaultRanger.create(:best_estimate => new_ts_range)
        range.reload
        range.best_estimate.should eq new_ts_range
      end
    end
  end
end
