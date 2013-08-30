require 'active_record/relation/query_methods'

module ActiveRecord
  module QueryMethods
    class WhereChain
      def overlap(opts)
        opts.each do |key, value|
          @scope = @scope.where(arel_table[key].overlap(value))
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

    [:with, :rank].each do |name|
      class_eval <<-CODE, __FILE__, __LINE__ + 1
       def #{name}_values                   # def select_values
         @values[:#{name}] || []            #   @values[:select] || []
       end                                  # end
                                            #
       def #{name}_values=(values)          # def select_values=(values)
         raise ImmutableRelation if @loaded #   raise ImmutableRelation if @loaded
         @values[:#{name}] = values         #   @values[:select] = values
       end                                  # end
      CODE
    end

    def with(*args)
      check_if_method_has_arguments!('with', args)
      spawn.with!(*args.compact.flatten)
    end

    def with!(*args)
      self.with_values += args
      self
    end

    def ranked(options = :order)
      spawn.ranked! options
    end

    def ranked!(*args)
      self.rank_values += args
      self
    end

    def build_arel_with_extensions
      arel = build_arel_without_extensions

      build_with(arel, with_values)

      build_rank(arel, rank_values)

      arel
    end

    def build_with(arel, withs)
      withs.each do |with_value|
        case with_value
        when String
          arel.with with_value
        when Hash
          with_value.each  do |name, expression|
            case expression
            when String
              select = Arel::SqlLiteral.new "(#{expression})"
            when ActiveRecord::Relation
              select = Arel::SqlLiteral.new "(#{expression.to_sql})"
            end
            as = Arel::Nodes::As.new Arel::SqlLiteral.new(name.to_s), select
            arel.with as
          end
        end
      end
    end

    def build_rank(arel, ranks)
      rank_orders = ranks.uniq.reject(&:blank?).flat_map do |value|
        case value
        when :order
          arel.orders
        when Symbol
          table[value].asc
        when Hash
          value.map { |field, dir| table[field].send(dir) }
        else
          Arel::Nodes::SqlLiteral.new value
        end
      end

      unless rank_orders.blank?
        rank_node = Arel::Nodes::SqlLiteral.new 'rank()'
        window = Arel::Nodes::Window.new.order(rank_orders)
        over_node = Arel::Nodes::Over.new rank_node, window

        arel.project(over_node)
      end
    end

    alias_method_chain :build_arel, :extensions
  end
end
