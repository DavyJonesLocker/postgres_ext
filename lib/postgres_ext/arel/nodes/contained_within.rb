require 'arel/nodes/binary'
module Arel
  module Nodes
    class ContainedWithin < Arel::Nodes::Binary
      def operator; :<< end
    end

    class ContainedWithinEquals < Arel::Nodes::Binary
      def operator; '<<='.to_sym end
    end

    class Contains < Arel::Nodes::Binary
      def operator; :>> end
    end

    class ContainsEquals < Arel::Nodes::Binary
      def operator; '>>='.to_sym end
    end
  end
end
