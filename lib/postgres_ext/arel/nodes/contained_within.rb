require 'arel/nodes/binary'
require 'debugger'
module Arel
  module Nodes
    class ContainedWithin < Arel::Nodes::Binary
      def operator; :<< end
    end

    class ArrayOverlap < Arel::Nodes::Binary
      def operator; '&&' end
    end
  end
end
