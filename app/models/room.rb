class Room < ActiveRecord::Base
  belongs_to :building
  belongs_to :master, :class_name => "Student", :foreign_key => "student_id"
  belongs_to :info_class
  has_many :beds
  has_many :roommates, :through => :beds, :source => :student
  before_save :validates_master_from_roommates
  before_update :validates_no_students_in_before_change_type

  def genarate_bed
    self.bed_count.times do |no|
      bed = self.beds.new
      bed.number = no + 1
      begin
        bed.save
      rescue => error
        puts error
      end
    end
  end

  def find_a_free_bed
    free_bed = nil
    self.beds.each do |b|
      unless b.student
        free_bed = b
        break
      end
    end
    return free_bed
  end

  private
  def validates_no_students_in_before_change_type
    if self.changed.include?("room_type") and !self.roommates.empty?
      raise "更改宿舍类型必须先让该宿舍所有成员退出宿舍"
    end
  end

  def validates_master_from_roommates
		if self.master
			unless self.roommates.include?(self.master)
				raise "舍长必须是宿舍成员之一"
			end
		end
	end
end
