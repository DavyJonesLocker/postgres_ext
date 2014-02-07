require 'arel/nodes/binary'

module Arel
  module Nodes
    class PGMatches < Arel::Nodes::Binary
      def operator; :~ end
    end

    class PGDoesNotMatch < Arel::Nodes::Binary
      def operator; :"!~" end
    end
  end
end
