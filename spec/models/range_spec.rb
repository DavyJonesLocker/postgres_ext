require 'spec_helper'

describe 'Models with numeric range columns' do
  let!(:adapter) { ActiveRecord::Base.connection }

  context 'numrange' do
    context 'no default value, range' do
      before do
        adapter.create_table :rangers, :force => true do |t|
          t.numrange :best_estimate
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

    context 'default value, numeric range' do
      before do
        adapter.create_table :default_rangers, :force => true do |t|
          t.numrange :best_estimate, :default => 0..5
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

  context 'int4range' do
    context 'no default value, range' do
      before do
        adapter.create_table :int4_rangers, :force => true do |t|
          t.int4range :best_estimate
        end
        class Int4Ranger < ActiveRecord::Base
          attr_accessible :best_estimate
        end
      end

      after do
        adapter.drop_table :int4_rangers
        Object.send(:remove_const, :Int4Ranger)
      end

      describe '#create' do
        it 'creates an record when there is no assignment' do
          range = Int4Ranger.create()
          range.reload
          range.best_estimate.should eq nil
        end

        it 'creates an record with a range' do
          range = Int4Ranger.create( :best_estimate => 0..4)
          range.reload
          range.best_estimate.should eq 0...5
        end
      end

      describe 'range assignment' do
        it 'updates an record with an range string' do
          range = Int4Ranger.create( :best_estimate => 0..4)
          range.best_estimate = 0...9
          range.save

          range.reload
          range.best_estimate.should eq 0...9
        end

        it 'converts empty strings to nil' do
          range = Int4Ranger.create
          range.best_estimate = ''
          range.save

          range.reload
          range.best_estimate.should eq nil
        end
      end
    end

    context 'default value, int4 range' do
      before do
        adapter.create_table :int4_default_rangers, :force => true do |t|
          t.int4range :best_estimate, :default => 0..5
        end
        class Int4DefaultRanger < ActiveRecord::Base
          attr_accessible :best_estimate
        end
      end

      after do
        adapter.drop_table :int4_default_rangers
        Object.send(:remove_const, :Int4DefaultRanger)
      end

      describe '#create' do
        it 'creates an record when there is no assignment' do
          range = Int4DefaultRanger.create()
          range.reload
          range.best_estimate.should eq 0...6
        end

        it 'creates an record with a range' do
          range = Int4DefaultRanger.create( :best_estimate => 0..4)
          range.reload
          range.best_estimate.should eq 0...5
        end
      end
    end
  end

  context 'int8range' do
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

  context 'daterange' do
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
end
