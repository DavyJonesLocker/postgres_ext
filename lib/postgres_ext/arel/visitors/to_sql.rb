require 'arel/visitors/to_sql'

module Arel
  module Visitors
    class ToSql
      def visit_Array o
        quote(o, last_column)
      end
    end
  end
end
