class Bed < ActiveRecord::Base
  belongs_to :room
  belongs_to :student
end
