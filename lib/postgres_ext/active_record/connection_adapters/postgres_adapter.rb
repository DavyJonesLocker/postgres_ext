require 'active_record/connection_adapters/postgresql_adapter'

module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLColumn
      private

      def simplified_type(field_type)
        case field_type
        when 'inet'
          :inet
        when 'cidr'
          :cidr
        when 'macaddr'
          :macaddr
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

        def cidr(*args)
          options = args.extract_options!
          column(args[0], 'cidr', options)
        end

        def macaddr(*args)
          options = args.extract_options!
          column(args[0], 'macaddr', options)
        end
      end
      NATIVE_DATABASE_TYPES.merge!(:inet => {:name => 'inet'}, :cidr => {:name => 'cidr'}, :macaddr => {:name => 'macaddr'})
    end
  end
end
