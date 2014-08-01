require 'postgres_ext/active_record/connection_adapters/postgresql_adapter'

require 'active_record/connection_adapters/postgresql_adapter'
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send :prepend,
  PostgresExt::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
