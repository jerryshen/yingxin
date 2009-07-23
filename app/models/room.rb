class Room < ActiveRecord::Base
  belongs_to :building
  belongs_to :master, :class_name => "Student", :foreign_key => "student_id"
  belongs_to :info_class
  has_many :beds
  
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
end
