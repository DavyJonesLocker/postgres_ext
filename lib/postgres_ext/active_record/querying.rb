require 'active_record/querying'

module ActiveRecord::Querying
  delegate :with, to: :all
end
