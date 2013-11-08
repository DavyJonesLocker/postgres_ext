require 'spec_helper'

describe 'Exception handling via validations' do
  skip unless defined?(PG::Result::PG_DIAG_COLUMN_NAME)
  describe '#save' do
    context 'Not-Null columns' do
      it 'stops throwing exceptions when PostgreSQL errors' do
        result = nil
        lambda do
          thing = Thing.new
          result = thing.save
        end.should_not raise_exception

        result.should be_false
      end

      it 'sets the proper errors for NOT NULL attributes' do
        thing = Thing.new
        thing.save

        thing.errors[:title].should eq ["can't be blank"]
      end
    end

    context 'unique columns' do
      before { Thing.create! name: 'Test', title: 'something' }
      it 'stops throwing exceptions when PostgreSQL errors' do
        result = nil
        lambda do
          thing = Thing.new name: 'Test', title: 'something'
          result = thing.save
        end.should_not raise_exception

        result.should be_false
      end

      it 'sets the proper errors for NOT NULL attributes' do
        thing = Thing.new name: 'Test', title: 'something'
        thing.save

        thing.errors[:name].should eq ["has already been taken"]
      end
    end
  end
end
