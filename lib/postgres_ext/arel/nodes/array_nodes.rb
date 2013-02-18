require 'arel/nodes/binary'

module Arel
  module Nodes
    class ArrayOverlap < Arel::Nodes::Binary
      def operator; '&&' end
    end

    class ArrayContains < Arel::Nodes::Binary
      def operator; '@>' end
    end
  end
end