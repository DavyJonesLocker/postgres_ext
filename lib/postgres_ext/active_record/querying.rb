require 'active_record/querying'
require 'byebug'

module ActiveRecord::Querying
  delegate :with, to: :all
end
