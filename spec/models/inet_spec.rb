require 'spec_helper'

describe 'Models with inet columns' do
  let!(:adapter) { ActiveRecord::Base.connection }

  context 'no default value, inet' do
    before do
      adapter.create_table :addresses, :force => true do |t|
        t.inet :ip_address
      end
      class Address < ActiveRecord::Base
        attr_accessible :ip_address
      end
    end

    after do
      adapter.drop_table :addresses
      Object.send(:remove_const, :Address)
    end

    context 'no default value, inet' do
      describe '#create' do
        it 'creates an address when there is no assignment' do
          address = Address.create()
          address.reload
          address.ip_address.should eq nil
        end

        it 'creates an address with an address string' do
          address = Address.create( :ip_address => '192.168.0.1')
          address.reload
          address.ip_address.should eq IPAddr.new('192.168.0.1')
        end

        it 'creates an address with an IPAddr' do
          ip_addr = IPAddr.new('192.168.0.1')
          address = Address.create( :ip_address => ip_addr)
          address.reload
          address.ip_address.should eq ip_addr
        end
      end

      describe 'inet assignment' do
        it 'updates an address with an address string' do
          address = Address.create( :ip_address => '192.168.0.1')
          address.ip_address = '192.168.1.2'
          address.save

          address.reload
          address.ip_address.should eq IPAddr.new('192.168.1.2')
        end

        it 'updates an address with an IPAddr' do
          ip_addr_1 = IPAddr.new('192.168.0.1')
          ip_addr_2 = IPAddr.new('192.168.1.2')
          address = Address.create( :ip_address => ip_addr_1)
          address.ip_address = ip_addr_2
          address.save

          address.reload
          address.ip_address.should eq ip_addr_2
        end
      end

      describe 'find_by_inet' do
        let!(:address) { Address.create(:ip_address => '192.168.0.1') }

        it 'finds address using string value' do
          Address.find_by_ip_address('192.168.0.1').should eq address
        end

        it 'finds address using IPAddr' do
          ip_addr = IPAddr.new '192.168.0.1'
          Address.find_by_ip_address(ip_addr).should eq address
        end
      end
    end
  end
end
