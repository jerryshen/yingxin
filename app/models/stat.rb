class Stat

  #Count by entire college 
  def self.get_stat_data
    arr = []
    ar_stus = Student.count  #录取人数
    ov_stus = Student.count(:conditions => ["confirm = ?", true])  #实际报到人数
    percent = (ov_stus / ar_stus*100).round(2).to_s + "%"
    arr << ar_stus
    arr << ov_stus
    arr << percent
  end

  #Count by departs and majors
  def self.get_detail_data
    arr = []
    departments = Department.find(:all, :conditions => ["de_type =?", true])

    departments.each do |dep|
      dep.majors.each do |m|
        ar_stus = Student.count(:conditions => ["major_id =?", m.id])
        ov_stus = Student.count(:conditions => ["major_id =? AND confirm =?", m.id, true])
        la_stus = Student.find(:all,
          :conditions => ["major_id =? AND confirm =?",m.id, false],
          :group => "info_class_id",
          :order => "stu_number ASC"
        )
        percent = (ov_stus / ar_stus*100).round(2).to_s + "%"
        arr.push([m, ar_stus, ov_stus, percent, la_stus])
      end
    end
    return arr
  end

  #conditions stat
  def self.back_data
    ar_count = Proce.count(:conditions => ["step1 =?", true])
    br_stus  = Proce.find(:all, :conditions => ["step1=? AND step2 =?", true, false])
    br_count = br_stus.length
    arr = [ar_count, br_count, br_stus]

  end

end
