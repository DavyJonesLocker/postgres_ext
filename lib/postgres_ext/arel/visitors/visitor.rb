require 'arel/visitors/visitor'
module Arel
  module Visitors
    class Visitor
      # We are adding our visitors to the main visitor for the time being until the right spot is found to monkey patch
      private
      def visit_Arel_Nodes_ContainedWithin o, a = nil
        "#{visit o.left, a} << #{visit o.right, o.left}"
      end

      def visit_Arel_Nodes_ContainedWithinEquals o, a = nil
        "#{visit o.left, a} <<= #{visit o.right, o.left}"
      end

      def visit_Arel_Nodes_Contains o, a = nil
        left_column = o.left.relation.engine.columns.find { |col| col.name == o.left.name.to_s }

        if left_column && (left_column.type == :hstore || (left_column.respond_to?(:array) && left_column.array))
          "#{visit o.left, a} @> #{visit o.right, o.left}"
        else
          "#{visit o.left, a} >> #{visit o.right, o.left}"
        end
      end

      def visit_Arel_Nodes_ContainsEquals o, a = nil
        "#{visit o.left, a} >>= #{visit o.right, o.left}"
      end

      def visit_Arel_Nodes_Overlap o, a = nil
        "#{visit o.left, a} && #{visit o.right, o.left}"
      end

      def visit_IPAddr value, a = nil
        "'#{value.to_s}/#{value.instance_variable_get(:@mask_addr).to_s(2).count('1')}'"
      end
    end
  end
end
