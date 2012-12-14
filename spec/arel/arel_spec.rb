require 'spec_helper'

describe 'Don\'t stomp all over the default ActiveRecord queries' do
  let!(:adapter) { ActiveRecord::Base.connection }

  before do
    adapter.create_table :cars, :force => true do |t|
      t.string :make
      t.string :model
      t.timestamps
    end

    class Car < ActiveRecord::Base
      attr_accessible :make, :model
    end
  end

  after do
    adapter.drop_table :cars
    Object.send(:remove_const, :Car)
  end

  describe 'Where Queries' do
    describe 'Set query' do
      it '' do
        Car.where('id in (?)', [1,2]).to_sql.should eq "SELECT \"cars\".* FROM \"cars\"  WHERE (id in (1,2))"
      end
    end
  end
end
