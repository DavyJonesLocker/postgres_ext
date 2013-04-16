require 'spec_helper'

describe 'Models with ean13 columns' do
  let!(:adapter) { ActiveRecord::Base.connection }

  context 'no default value, ean' do
    before do
      adapter.create_table :books, :force => true do |t|
        t.ean13 :ean
      end

      class Book < ActiveRecord::Base
        attr_accessible :ean
      end
    end

    after do
      adapter.drop_table :books
      Object.send(:remove_const, :Book)
    end

    context 'no default value, ean' do
      describe '#create' do
        it 'create a book when there is no ean assignment' do
          book = Book.create()
          book.reload
          book.ean.should eq nil
        end

        it 'creates a book with an ean string' do
          book = Book.create(:ean => '9780312174910')
          book.reload
          book.ean.should eq '978-0-312-17491-0'
        end
      end

      describe 'ean assignment' do
        it 'updates a book with an ean string' do
          book = Book.create(:ean => '9783037781265')
          book.ean = '9780312174910'
          book.save

          book.reload
          book.ean.should eq '978-0-312-17491-0'
        end
      end

      describe 'find_by_ean' do
        let!(:ean) { Book.create(:ean => '9783037781265') }

        it 'finds book using string value' do
          Book.find_by_ean('9783037781265').should eq ean
        end
      end
    end
  end
end
