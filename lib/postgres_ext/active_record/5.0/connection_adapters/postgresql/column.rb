module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLColumn < Column
      def type
        sql_type_metadata.sql_type.to_sym
      end
    end
  end
end