require 'arel/visitors/visitor'
module Arel
  module Visitors
    class Visitor
      # We are adding our visitors to the main visitor for the time being until the right spot is found to monkey patch
      private
      def visit_Arel_Nodes_ContainedWithin o
        "#{visit o.left} << #{visit o.right}"
      end

      def visit_Arel_Nodes_ContainedWithinEquals o
        "#{visit o.left} <<= #{visit o.right}"
      end

      def visit_Arel_Nodes_Contains o
        left_column = o.left.relation.engine.columns.find { |col| col.name == o.left.name.to_s }

        if left_column && left_column.respond_to?(:array) && left_column.array
          "#{visit o.left} @> #{visit o.right}"
        else
          "#{visit o.left} >> #{visit o.right}"
        end
      end

      def visit_Arel_Nodes_ContainsEquals o
        "#{visit o.left} >>= #{visit o.right}"
      end

      def visit_Arel_Nodes_Overlap o
        "#{visit o.left} && #{visit o.right}"
      end

      def visit_IPAddr value
        "'#{value.to_s}/#{value.instance_variable_get(:@mask_addr).to_s(2).count('1')}'"
      end
    end
  end
end
