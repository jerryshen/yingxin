class Student < ActiveRecord::Base
  belongs_to :department, :foreign_key => 'department_id'
  belongs_to :major, :foreign_key => 'major_id'
  belongs_to :info_class, :foreign_key => 'info_class_id'

  belongs_to :room_student

  def self.to_json
    hash = {}
    find_by_sql("select id,name from students").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash.to_json
  end
end
