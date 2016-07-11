require 'postgres_ext/active_record/relation/query_methods'

module ActiveRecord
  module QueryMethods
    class WhereChain
      private

      def left_column(rel)
        rel.left.relation.engine.columns.find { |col| find_column(col, rel) }
      end

      def build_where_chain(opts, rest, &block)
        where_value = @scope.send(:build_where, opts, rest).map(&block)
        @scope.references!(PredicateBuilder.references(opts)) if Hash === opts
        @scope.where_values += where_value
        @scope
      end
    end
  end
end