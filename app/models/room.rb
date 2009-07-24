class Room < ActiveRecord::Base
  belongs_to :building
  belongs_to :master, :class_name => "Student", :foreign_key => "student_id"
  belongs_to :info_class
  has_many :beds
  has_many :roommates, :through => :beds, :source => :student
  before_save :validates_master_from_roommates

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

  private
  	def validates_master_from_roommates
		if self.master
			unless self.roommates.include?(self.master)
				raise "舍长必须是宿舍成员之一"
			end
		end
	end
end
