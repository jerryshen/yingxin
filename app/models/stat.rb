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
    return arr
  end

  #Count by departs and majors
  def self.get_detail_data
    arr = []
    majors = Major.all
    majors.each do |m|
      ar_stus = Student.count(:conditions => ["major_id =?", m.id])
      ov_stus = Student.count(:conditions => ["major_id =? AND confirm =?", m.id, true])
      la_stus = Student.find(:all,
        :conditions => ["major_id =? AND confirm =?",m.id, false])
      percent = ar_stus == 0 ? "0%" : (ov_stus / ar_stus*100).to_s + "%"
      arr.push({"major_id" =>m.id, "ar_count" => ar_stus, "ov_count" => ov_stus, "percent" => percent, "la" => la_stus})
    end
    return arr
  end

  #conditions stat
  def self.back_data
    ar_count = Proce.count(:conditions => ["step1 =?", true])
    br_stus  = Proce.find(:all, :conditions => ["step1=? AND step2 =?", true, false])
    br_count = br_stus.length
    arr = [ar_count, br_count, br_stus]
    return arr
  end

  def self.search(department_id)
    arr = []
    Stat.get_detail_data.each do |t|
      if Major.find(t["major_id"]).department.id == department_id
        arr << t
      end
    end
  end
end