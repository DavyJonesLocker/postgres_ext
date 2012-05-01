require 'arel/visitors/to_sql'
module Arel
  module Visitors
    class ToSql
      private
      def visit_Arel_Nodes_ContainedWithin o
        "#{visit o.left} << #{visit o.right}"
      end

    end
  end
end
