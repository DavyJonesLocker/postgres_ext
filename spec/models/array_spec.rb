require 'spec_helper'

describe 'Models with array columns' do
  let!(:adapter) { ActiveRecord::Base.connection }

  context 'no default value, string array' do
    before do
      adapter.create_table :users, :force => true do |t|
        t.string :nick_names, :array => true

        t.timestamps
      end

      class User < ActiveRecord::Base
        attr_accessible :nick_names
      end
    end

    after do
      adapter.drop_table :users
      Object.send(:remove_const, :User)
    end

    context 'no default value, string array' do
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

    context 'Setting values' do
      describe 'setting a new value' do
        it 'returns the value set when the record is retrieved' do
          u = User.create(:nick_names => ['some', 'things'])
          u.reload

          u.nick_names = ['different', 'values']
          u.save

          u.reload
          u.nick_names.should eq ['different', 'values']
        end
      end
    end

    context '#update_attribute' do
      describe 'setting a value via update_attribute' do
        it 'returns the value set when the record is retrieved' do
          user = User.create(:nick_names => [])
          user.reload

          user.update_attribute(:nick_names, ['some', 'values'])
          user.save

          user.reload
          user.nick_names.should eq ['some', 'values']
        end
      end
    end

    context '#update_attributes' do
      describe 'setting a value via update_attributes' do
        it 'returns the value set when the record is retrieved' do
          user = User.create(:nick_names => [])
          user.reload

          user.update_attributes(:nick_names => ['some', 'values'])
          user.save

          user.reload
          user.nick_names.should eq ['some', 'values']
        end
      end
    end

    describe 'strings contain special characters' do
      context '#save' do
        it 'contains: \'' do
          data = ['some\'thing']
          u = User.create
          u.nick_names = data
          u.save!
          u.reload
          u.nick_names.should eq data
        end

        it 'contains: {' do
          data = ['some{thing']
          u = User.create
          u.nick_names = data
          u.save!
          u.reload
          u.nick_names.should eq data
        end

        it 'contains: }' do
          data = ['some}thing']
          u = User.create
          u.nick_names = data
          u.save!
          u.reload
          u.nick_names.should eq data
        end

        it 'contains: backslash' do
          data = ['some\\thing']
          u = User.create
          u.nick_names = data
          u.save!
          u.reload
          u.nick_names.should eq data
        end

        it 'contains: "' do
          data = ['some"thing']
          u = User.create
          u.nick_names = data
          u.save!
          u.reload
          u.nick_names.should eq data
        end
      end

      context '#create' do
        it 'contains: \'' do
          data = ['some\'thing']
          u = User.create(:nick_names => data)
          u.reload
          u.nick_names.should eq data
        end

        it 'contains: {' do
          data = ['some{thing']
          u = User.create(:nick_names => data)
          u.reload
          u.nick_names.should eq data
        end

        it 'contains: }' do
          data = ['some}thing']
          u = User.create(:nick_names => data)
          u.reload
          u.nick_names.should eq data
        end

        it 'contains: backslash' do
          data = ['some\\thing']
          u = User.create(:nick_names => data)
          u.reload
          u.nick_names.should eq data
        end

        it 'contains: "' do
          data = ['some"thing']
          u = User.create(:nick_names => data)
          u.reload
          u.nick_names.should eq data
        end
      end
    end

    describe 'array_overlap' do
      it "works" do
        arel = User.arel_table
        User.create(:nick_names => ['this'])
        x = User.create
        x.nick_names = ["s'o{m}e", 'thing']
        x.save
        u = User.where(arel[:nick_names].array_overlap(["s'o{m}e"]))
        u.first.should_not be_nil
        u.first.nick_names.should eq ["s'o{m}e", 'thing']
      end
    end
  end

  context 'default values' do
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

    context 'model creation' do
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
end
