class Student < ActiveRecord::Base
  belongs_to :department, :foreign_key => 'department_id'
  belongs_to :major, :foreign_key => 'major_id'
  belongs_to :info_class, :foreign_key => 'info_class_id'

  belongs_to :room_student
  has_one :bed
  has_one :proce

  # process end
  def self.proc_end(proc)
    if proc.step1 && proc.step2 == true
      student = Student.find(proc.student_id)
      student.update_attributes(:confirm => true, :confirm_date => Time.now)
    end
  end

  #process restart
  def self.proc_restart(proc)
    if proc.step1 && proc.step2 == false
      student = Student.find(proc.student_id)
      student.update_attributes(:confirm => false, :confirm_date => nil)
    end
  end

  def self.to_json
    hash = {}
    self.find_by_sql("select id,name from students").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash.to_json
  end

  def self.get_can_num
    hash = {}
    self.find_by_sql("select id,can_number from students").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["can_number"]
    end
    return hash.to_json
  end

  def full_bed
    if bed
      room = bed.room
      "#{room.building.name}#{room.name}室#{bed.number}号床"
    else
      ""
    end
  end

  #import students to all steps and proces
  def self.import_to_proce
    all_stus = []
    self.all.each do |s|
      all_stus.push(s.id)
    end

    proc_stus = []
    Proce.all.each do |s|
      proc_stus.push(s.student_id)
    end

    ids = all_stus - proc_stus
    ids.each do |i|
      Proce.create(:student_id => i)
    end
  end

  def upload_thumb(file)
    begin
      old_thumb = self.thumb
      file_name = FileUploadUtil.make_timestamp_file_name(file)
      dir = "#{RAILS_ROOT}/public/uploads/thumbs"
      FileUploadUtil.save_file(file, dir, file_name)
      update_attributes!(:thumb => file_name)
      unless old_thumb.blank?
        path = dir + "/" + old_thumb
        File.delete(path) if File.exist? path
      end
      return self.thumb_url
    rescue 
      return ''
    end
  end
  
  def thumb_url
    unless self.thumb.blank?
      "/uploads/thumbs/#{self.thumb}" 
    else
      ""
    end
  end

  #dist classes
  def self.dispatch(major_id)
    boys = Student.find(:all, :conditions => {:gender => 'm',  :major_id => major_id, :info_class_id => nil}, :order => "h_score DESC")
    girls = Student.find(:all, :conditions => {:gender => 'f',  :major_id => major_id, :info_class_id => nil}, :order => "h_score DESC")
    classes = Major.find(major_id).info_classes
    sendto_class(classes, boys)
    sendto_class(classes, girls)
    return true
  end

  def self.auto_assigning_bed(ids)
    count = 0
    ids.each do |id|
      student = self.find(id)
      if student
        begin
         count += 1 if student.info_class.assigning_bed(student)
        rescue
        end
      end
    end
    return count
  end

  private
  def self.sendto_class(classes, students)
    i = 0
    count = classes.count
    students.each do |s|
      s.update_attributes(:info_class_id => classes[i].id)
      i += 1
      i=0 if(i==count)
    end
  end


end
