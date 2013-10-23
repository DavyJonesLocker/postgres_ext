require 'arel/visitors/to_sql'

module Arel
  module Visitors
    class ToSql
      def visit_Array o, a
        column = a.relation.engine.columns.find { |col| col.name == a.name.to_s } if a
        if column && column.respond_to?(:array) && column.array
          quoted o, a
        else
          o.empty? ? 'NULL' : o.map { |x| visit x }.join(', ')
        end
      end
    end
  end
end
