require 'arel/visitors/to_sql'

module Arel
  module Visitors
    class ToSql
      def visit_Array o, a
        column = a.relation.engine.connection.columns(a.relation.name).find { |col| col.name == a.name.to_s } if a
        if column && column.respond_to?(:array) && column.array
          quoted o, a
        else
          o.empty? ? 'NULL' : o.map { |x| visit x }.join(', ')
        end
      end

      def visit_Arel_Nodes_PGMatches o, a = nil
        "#{visit o.left, a} ~ #{visit o.right, o.left}"
      end

      def visit_Arel_Nodes_PGDoesNotMatch o, a = nil
        "#{visit o.left, a} != #{visit o.right, o.left}"
      end
    end
  end
end
