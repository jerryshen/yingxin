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

  #import students to all steps and proces
  def self.import_to_steps
    students = self.all
    students.each do |s|
      Step1.create(:student_id => s.id)
      Step2.create(:student_id => s.id)
      Step3.create(:student_id => s.id)
      Step4.create(:student_id => s.id)
      Step5.create(:student_id => s.id)
      Step6.create(:student_id => s.id)
      Step7.create(:student_id => s.id)
      Proce.create(:student_id => s.id)
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

end
