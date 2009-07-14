class RoomStudent < ActiveRecord::Base
  belongs_to :room
  has_many :students
end
