require 'arel/predications'

module Arel
  module Predications
    def contained_within(other)
      Nodes::ContainedWithin.new self, other
    end
    
    def array_any_eq(other)
      Nodes::ArrayAnyEq.new self, other
    end

    def array_any
      Nodes::ArrayAny.new self
    end

    def array_all
      Nodes::ArrayAll.new self
    end

    def array_overlap(other)
      Nodes::ArrayOverlap.new self, other
    end
  end
end
