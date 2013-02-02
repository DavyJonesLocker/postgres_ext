require 'active_record/relation/query_methods'

module ActiveRecord
  module QueryMethods
    class WhereChain
      def initialize(scope)
        @scope = scope
      end

      def overlap(opts)
        opts.each do |key, value|
          arel_table = @scope.engine.arel_table
          @scope = @scope.where(arel_table[key].array_overlap(value))
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
