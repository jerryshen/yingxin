class Student < ActiveRecord::Base
  belongs_to :department, :foreign_key => 'department_id'
  belongs_to :major, :foreign_key => 'major_id'
  belongs_to :info_class, :foreign_key => 'info_class_id'

  belongs_to :room_student
end
