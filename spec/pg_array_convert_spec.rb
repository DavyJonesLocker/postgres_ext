require 'spec_helper'


describe 'PgArrayConvert' do
  include PostgresExt::PgArrayConvert

  it 'converts empty array' do
    convert_pg_array(%[{}]).should eq []
  end

  it 'convert single entry array' do
    convert_pg_array(%[{abc}]).should eq ['abc']
  end

  it 'convert multiple entry array' do
    convert_pg_array(%[{abc, def}]).should eq ['abc', 'def']
  end

  it 'convert array with quoted entry' do
    convert_pg_array(%[{abc, def, "some stuff"}]).should eq ['abc', 'def', 'some stuff']
  end
end

describe 'PgArrayRevert' do
  include PostgresExt::PgArrayRevert

  it 'reverts from empty array' do
    revert_pg_array([]).should eq nil
  end

  it 'reverts from single entry array' do
    revert_pg_array(['abc']).should eq(%[{abc}])
  end

  it 'reverts from multiple entry array' do
    revert_pg_array(['abc', 'def']).should eq(%[{abc, def}])
  end

  it 'revert from array with quoted entry' do
    revert_pg_array(['abc', 'def', 'some stuff']).should eq(%[{abc, def, some stuff}])
  end
end
