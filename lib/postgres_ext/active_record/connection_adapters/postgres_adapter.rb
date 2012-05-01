require 'active_record/connection_adapters/postgresql_adapter'

module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter
      class TableDefinition
        def inet(*args)
          options = args.extract_options!
          column(args[0], 'inet', options)
        end
      end
    end
  end
end
