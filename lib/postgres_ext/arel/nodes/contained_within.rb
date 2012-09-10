module Arel
  module Nodes
    class ContainedWithin < Arel::Nodes::Binary
      def operator; :<< end
      alias :operand1 :left
      alias :operand2 :right
    end

    class ArrayAnyEq < Arel::Nodes::Binary
      alias :operand1 :left
      alias :operand2 :right
    end
  end
end
