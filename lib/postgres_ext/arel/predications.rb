require 'arel/predications'

module Arel
  module Predications
    def contained_within other
      Nodes::ContainedWithin.new self, other
    end
  end
end
