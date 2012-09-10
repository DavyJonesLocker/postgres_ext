require 'arel/visitors/to_sql'
module Arel
  module Visitors
    class ToSql
      private
      def visit_Arel_Nodes_ContainedWithin o
        "#{visit o.left} << #{visit o.right}"
      end

      def visit_Arel_Nodes_ArrayAnyEq o
        "#{visit o.right} = ANY(#{visit o.left})"
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
        if value.match /"|,|{/
          value.gsub(/"/, "\"").gsub(/'/,'"')
        else
          value.gsub(/'/,'')
        end
      end
    end
  end
end
