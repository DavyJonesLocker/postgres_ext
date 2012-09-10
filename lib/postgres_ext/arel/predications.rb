require 'arel/predications'

module Arel
  module Predications
    def contained_within(other)
      Nodes::ContainedWithin.new self, other
    end
    
    def array_any_eq(other)
      Nodes::ArrayAnyEq.new self, other
    end
  end
end
