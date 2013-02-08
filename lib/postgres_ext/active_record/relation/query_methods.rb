require 'active_record/relation/query_methods'

module ActiveRecord
  module QueryMethods
    class WhereChain
      def initialize(scope)
        @scope = scope
      end

      def overlap(opts)
        opts.each do |key, value|
          @scope = @scope.where(arel_table[key].array_overlap(value))
        end
        @scope
      end

      def contained_within(opts)
        opts.each do |key, value|
          @scope = @scope.where(arel_table[key].contained_within(value))
        end

        @scope
      end

      def contained_within_or_equals(opts)
        opts.each do |key, value|
          @scope = @scope.where(arel_table[key].contained_within_or_equals(value))
        end

        @scope
      end

      def contains(opts)
        opts.each do |key, value|
          @scope = @scope.where(arel_table[key].contains(value))
        end

        @scope
      end

      def contains_or_equals(opts)
        opts.each do |key, value|
          @scope = @scope.where(arel_table[key].contains_or_equals(value))
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

      def arel_table
        @arel_table ||= @scope.engine.arel_table
      end

      def equality_to_function(function_name, opts)
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
