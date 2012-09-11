require 'arel/nodes/binary'
module Arel
  module Nodes
    class ContainedWithin < Arel::Nodes::Binary
      def operator; :<< end
      alias :operand1 :left
      alias :operand2 :right
    end

    class Binary
      def initialize(left, right)
        if ArrayAny === left
          @left = right
          @right = left
        else
          @left = left
          @right = right
        end
      end
    end

    class ArrayAnyEq < Arel::Nodes::Binary
    end

    class ArrayOverlap < Arel::Nodes::Binary
    end

    class ArrayAny < Arel::Attribute
    end
  end
end
