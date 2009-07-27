class Bed < ActiveRecord::Base
	belongs_to :room
	belongs_to :student

	validates_presence_of :room_id, :number
	before_save :validates_roommate_gender, :validates_bed_number, :validates_havnt_assigning

	private
	def validates_roommate_gender
		r_gender = self.room.room_type == 0 ? '男生' : '女生' 
		if self.student 
			b_gender = self.student.gender == 'm' ? '男生' : '女生' 
			if b_gender != r_gender
				raise "警告，#{b_gender}不能入住#{r_gender}宿舍！"
			end
		end
	end

  def validates_havnt_assigning
    if student && student.bed
      raise "该学生已经入住：#{student.full_bed}"
    end
  end

	def validates_bed_number
		bed_count = self.room.bed_count
		unless bed_count
			raise "请先为床位所在的房间设置床位总数"
		end
		unless (1..bed_count).include? self.number
			raise "床位编号(number)只能在1..#{bed_count}之间"
		end
		if self.room.beds.collect{|x| x.number if x != self}.include?(self.number)
			raise "#{self.room.name}宿舍已经存在编号为#{self.number}的床位"
		end
	end

end
