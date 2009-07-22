class Room < ActiveRecord::Base
  belongs_to :building
  belongs_to :master, :class_name => "Student", :foreign_key => "student_id"
  belongs_to :info_class
  has_many :beds
end
