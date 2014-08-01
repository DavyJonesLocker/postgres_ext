require 'test_helper'

describe 'Function Migrations' do
  describe 'add_function' do
    let(:connection) { ActiveRecord::Base.connection }
    let(:return_types) { connection.execute('select oid, typname from pg_type').map { |h| [h['oid'],h['typname']]}.to_h }
    let(:languages) { connection.execute('select oid, lanname from pg_language').map { |h| [h['oid'],h['lanname']]}.to_h }
    let(:function_definition) do
<<-SQLFUNCTION
DECLARE
  test varchar(255);
BEGIN
  SELECT 'test' INTO test;
  new.thing := test;
  RETURN new;
END
SQLFUNCTION
      .strip
    end

    after do
      connection.execute('DROP FUNCTION test_function();')
    end


    it 'creates the function' do
      connection.add_function 'test_function', function_definition, returns: 'trigger', language: 'plpgsql'

      function_details = connection.execute("SELECT * FROM pg_proc WHERE proname = 'test_function'").first
      function_details.wont_be_nil
      function_details['prosrc'].strip.must_equal function_definition
      return_types[function_details['prorettype']].must_equal 'trigger'
    end

    it 'sets the right return type' do
      connection.add_function 'test_function', function_definition, returns: 'trigger', language: 'plpgsql'
      function_details = connection.execute("SELECT * FROM pg_proc WHERE proname = 'test_function'").first
      return_types[function_details['prorettype']].must_equal 'trigger'

      connection.execute('DROP FUNCTION test_function();')

      connection.add_function 'test_function', "BEGIN SELECT 1; END", language: 'plpgsql'
      function_details = connection.execute("SELECT * FROM pg_proc WHERE proname = 'test_function'").first
      return_types[function_details['prorettype']].must_equal 'void'
    end

    it 'sets the right language' do
      connection.add_function 'test_function', function_definition, returns: 'trigger'
      function_details = connection.execute("SELECT * FROM pg_proc WHERE proname = 'test_function'").first
      languages[function_details['prolang']].must_equal 'plpgsql'

      connection.execute('DROP FUNCTION test_function();')

      connection.add_function 'test_function', 'SELECT 1', returns: 'integer', language: 'sql'
      function_details = connection.execute("SELECT * FROM pg_proc WHERE proname = 'test_function'").first
      languages[function_details['prolang']].must_equal 'sql'
    end
  end
end
