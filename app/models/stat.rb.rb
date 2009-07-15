class Stat

  #Count by entire college / departments / majors
  def self.get_stat_data(department_id, major_id)
    if department_id.blank?
      arr = []
      ar_stus = Student.count
      ov_stus = Student.count(:conditions => ["confirm = ?", true])
      percent = (ov_stus / ar_stus*100).round(2).to_s + "%"
      arr << ar_stus << ov_stus << percent
    else
      
    end
  end

end
