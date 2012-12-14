require 'arel/visitors/visitor'
module Arel
  module Visitors
    class Visitor
      # We are adding our visitors to the main visitor for the time being until the right spot is found to monkey patch
      private
      def visit_Arel_Nodes_ContainedWithin o
        "#{visit o.left} << #{visit o.right}"
      end

      def visit_Arel_Nodes_ArrayOverlap o
        if Array === o.right 
          right = "{#{o.right.map{|v| change_string(visit(v))}.join(',')}}"
          "#{visit o.left} && '#{right}'"
        else
          "#{visit o.left} && #{visit o.right}"
        end
      end

      def visit_IPAddr value
        "'#{value.to_s}/#{value.instance_variable_get(:@mask_addr).to_s(2).count('1')}'"
      end

      def change_string value
        return value unless value.is_a?(String)
        value.gsub(/^\'/, '"').gsub(/\'$/, '"')
      end
    end
  end
end
