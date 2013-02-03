require 'arel/visitors/to_sql'

module Arel
  module Visitors
    class ToSql
      def visit_Array o
        if last_column.respond_to?(:array) && last_column.array
          quoted o
        else
          o.map { |x| visit x }.join(', ')
        end
      end
    end
  end
end
