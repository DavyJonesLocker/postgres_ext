require 'arel/nodes/binary'
module Arel
  module Nodes
    class ContainedWithin < Arel::Nodes::Binary
      def operator; :<< end
    end

    class ArrayAnyEq < Arel::Nodes::Binary
    end

    class ArrayOverlap < Arel::Nodes::Binary
    end
  end
end
