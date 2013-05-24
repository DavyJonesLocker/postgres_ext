require 'spec_helper'

describe 'Models with daterange columns' do
  let!(:adapter) { ActiveRecord::Base.connection }

  context 'no default value, range' do
    before do
      adapter.create_table :date_rangers, :force => true do |t|
        t.daterange :best_estimate
      end
      class DateRanger < ActiveRecord::Base
        attr_accessible :best_estimate
      end
    end

    after do
      adapter.drop_table :date_rangers
      Object.send(:remove_const, :DateRanger)
    end

    describe '#create' do
      it 'creates an record when there is no assignment' do
        range = DateRanger.create()
        range.reload
        range.best_estimate.should eq nil
      end

      it 'creates an record with a range' do
        date_range = Date.new(2011, 01, 01)..Date.new(2012, 01, 31)
        range = DateRanger.create( :best_estimate => date_range)
        range.reload
        range.best_estimate.should eq Date.new(2011, 01, 01)...Date.new(2012, 02, 01)
      end
    end

    describe 'range assignment' do
      it 'updates an record with an range string' do
        date_range = Date.new(2011, 01, 01)..Date.new(2012, 01, 31)
        new_date_range = Date.new(2012, 01, 01)...Date.new(2012, 02, 01)
        range = DateRanger.create( :best_estimate => date_range)
        range.best_estimate = new_date_range
        range.save

        range.reload
        range.best_estimate.should eq new_date_range
      end

      it 'converts empty strings to nil' do
        range = DateRanger.create
        range.best_estimate = ''
        range.save

        range.reload
        range.best_estimate.should eq nil
      end
    end
  end

  context 'default value, date range' do
    before do
      adapter.create_table :date_default_rangers, :force => true do |t|
        t.daterange :best_estimate, :default => Date.new(2011, 01, 01)..Date.new(2011, 01, 31)
      end
      class DateDefaultRanger < ActiveRecord::Base
        attr_accessible :best_estimate
      end
    end

    after do
      adapter.drop_table :date_default_rangers
      Object.send(:remove_const, :DateDefaultRanger)
    end

    describe '#create' do
      it 'creates an record when there is no assignment' do
        range = DateDefaultRanger.create()
        range.reload
        range.best_estimate.should eq Date.new(2011, 01, 01)...Date.new(2011, 02, 01)
      end

      it 'creates an record with a range' do
        range = DateDefaultRanger.create(:best_estimate => Date.new(2012, 01, 01)..Date.new(2012, 12, 31))
        range.reload
        range.best_estimate.should eq Date.new(2012, 01, 01)...Date.new(2013, 01, 01)
      end
    end
  end
end
