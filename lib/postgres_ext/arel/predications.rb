require 'arel/predications'

module Arel
  module Predications
    def contained_within(other)
      Nodes::ContainedWithin.new self, other
    end

    def array_overlap(other)
      Nodes::ArrayOverlap.new self, other
    end
  end
end
