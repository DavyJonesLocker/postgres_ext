require 'arel/predications'

module Arel
  module Predications
    def contained_within(other)
      Nodes::ContainedWithin.new self, other
    end

    def contained_within_or_equals(other)
      Nodes::ContainedWithinEquals.new self, other
    end

    def contains(other)
      Nodes::Contains.new self, other
    end

    def contains_or_equals(other)
      Nodes::ContainsEquals.new self, other
    end

    def array_overlap(other)
      Nodes::ArrayOverlap.new self, other
    end
  end
end
