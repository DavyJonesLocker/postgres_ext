require 'postgres_ext/active_record/relation/query_methods'

module ActiveRecord
  module QueryMethods
    class WhereChain
      private

      def left_column(rel)
        @scope.klass.columns_hash[rel.left.name] || @scope.klass.columns_hash[rel.left.relation.name]
      end

      def build_where_chain(opts, rest, &block)
        where_clause = @scope.send(:where_clause_factory).build(opts, rest)
        @scope.references!(PredicateBuilder.references(opts)) if Hash === opts
        @scope.where_clause += where_clause.modified_predicates(&block)
        @scope
      end
    end
  end
end