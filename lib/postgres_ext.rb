require 'postgres_ext/version'
require 'postgres_ext/active_record'
require 'postgres_ext/arel'

require 'active_record/relation/predicate_builder'
require 'active_record/querying'
require 'active_record/relation/query_methods'

ActiveRecord::PredicateBuilder.send :prepend, PostgresExt::ActiveRecord::PredicateBuilder
ActiveRecord::Querying.send :prepend, PostgresExt::ActiveRecord::Querying
ActiveRecord::Relation.send :prepend, PostgresExt::ActiveRecord::QueryMethods
ActiveRecord::QueryMethods::WhereChain.send :prepend, PostgresExt::ActiveRecord::QueryMethods::WhereChain
