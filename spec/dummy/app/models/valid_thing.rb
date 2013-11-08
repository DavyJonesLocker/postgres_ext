class ValidThing < ActiveRecord::Base
  self.table_name = 'things'
  validates :title, presence: true
end
