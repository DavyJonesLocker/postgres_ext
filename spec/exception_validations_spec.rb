require 'spec_helper'

describe 'Exception handling via validations' do
  describe '#save' do
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
end
