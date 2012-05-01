require 'active_record/connection_adapters/postgresql_adapter'

module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLColumn
      private

      def simplified_type(field_type)
        case field_type
        when 'inet'
          :inet
        else
          super
        end
      end
    end
    class PostgreSQLAdapter
      class TableDefinition
        def inet(*args)
          options = args.extract_options!
          column(args[0], 'inet', options)
        end
      end
      NATIVE_DATABASE_TYPES.merge!(:inet => {:name => 'inet'})
    end
  end
end
