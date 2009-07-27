class InfoClass < ActiveRecord::Base
  belongs_to :major
  has_many :students
  has_many :rooms

  def self.to_json
    hash = {}
    find_by_sql("select id,name from info_classes").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash.to_json
  end


  def students_to_json
    ar_classes = self.students.collect do |row|
      {:id => row.id, :name => row.name}
    end
    ar_classes.to_json
  end


  def assigning_bed(student)
    bed = find_an_unassigning_bed(student.gender)
    if bed
      bed.student = student
      bed.save
      return true
    end
    return false
  end

  private
  #查找出该班的一个空床位
  def find_an_unassigning_bed(gender)
    bed = nil
    rs = self.rooms
    rs.each do |r|
      if r.room_type == (gender == "m" ? 0 : 1)
        bed = r.find_a_free_bed()
        break if bed
      end
    end
    return bed
  end
end
