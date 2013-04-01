class Person < ActiveRecord::Base
  attr_accessible :ip, :tags, :tag_ids, :biography, :lucky_number, :int_range
end
