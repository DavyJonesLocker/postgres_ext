require 'active_record/relation/query_methods'

module ActiveRecord
  module QueryMethods
    class WhereChain
      def initialize(scope)
        @scope = scope
      end

      def overlap(opts)
        arel_table = @scope.engine.arel_table
        opts.each do |key, value|
          @scope = @scope.where(arel_table[key].array_overlap(value))
        end
        @scope
      end

      def any(opts)
        equality_to_function('ANY', opts)
      end

      def all(opts)
        equality_to_function('ALL', opts)
      end

      private

      def equality_to_function(function_name, opts)
        arel_table = @scope.engine.arel_table

        opts.each do |key, value|
          any_function = Arel::Nodes::NamedFunction.new(function_name, [arel_table[key]])
          predicate = Arel::Nodes::Equality.new(value, any_function)
          @scope = @scope.where(predicate)
        end

        @scope
      end
    end

    def where_with_chaining(opts = :chaining, *rest)
      if opts == :chaining
        WhereChain.new(self)
      else
        where_without_chaining(opts, *rest)
      end
    end

    alias_method_chain :where, :chaining
  end
end
