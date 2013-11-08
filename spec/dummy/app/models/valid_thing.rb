class ValidThing < ActiveRecord::Base
  self.table_name = 'things'
  validates :title, presence: true
  validates :name, uniqueness: true
end
