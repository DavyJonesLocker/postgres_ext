require 'spec_helper'

describe 'Models with array columns' do
  context 'no default value, string array' do
    let!(:adapter) { ActiveRecord::Base.connection }

    before do
      adapter.create_table :users, :force => true do |t|
        t.string :nick_names, :array => true
      end
      class User < ActiveRecord::Base
        attr_accessible :nick_names
      end
    end

    after do
      adapter.drop_table :users
      Object.send(:remove_const, :User)
    end

    describe '#create' do
      it 'creates a user when there is no array assignment' do
        u = User.create()
        u.reload
        u.nick_names.should eq nil
      end

      it 'creates a user with an empty array' do
        u = User.create(:nick_names => [])
        u.reload
        u.nick_names.should eq []
      end

      it 'creates a user with an array of some values' do
        u = User.create(:nick_names => ['some', 'things'])
        u.reload
        u.nick_names.should eq ['some', 'things']
      end
    end
  end

  context 'default value, string array' do
    let!(:adapter) { ActiveRecord::Base.connection }
    before do
      adapter.create_table :defaulted_users, :force => true do |t|
        t.string :nick_names, :array => true, :default => '{}'
      end
      class DefaultedUser < ActiveRecord::Base
        attr_accessible :nick_names
      end
    end

    after do
      adapter.drop_table :defaulted_users
      Object.send(:remove_const, :DefaultedUser)
    end

    describe '#create' do
      it 'creates a user when there is no array assignment' do
        u = DefaultedUser.create()
        u.reload
        u.nick_names.should eq []
      end

      it 'creates a user with an nil' do
        u = DefaultedUser.create(:nick_names => nil)
        u.reload
        u.nick_names.should eq nil
      end

      it 'creates a user with an array of some values' do
        u = DefaultedUser.create(:nick_names => ['some', 'things'])
        u.reload
        u.nick_names.should eq ['some', 'things']
      end
    end
  end
end
