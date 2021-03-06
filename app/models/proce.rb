class Proce < ActiveRecord::Base
  belongs_to :student

  #  before_update :re_verify
  #
  #  # the first step is ness.
  #  def re_verify
  #    raise false if self.step1 == false
  #  end

  def self.get_gender
    hash = {}
    find_by_sql("select id,gender from students").each do |row|
      attrs = row.attributes
      gender = attrs["gender"] == "m" ? "男" : "女"
      hash[attrs["id"]] = gender
    end
    return hash.to_json
  end

  def self.get_major
    hash = {}
    find_by_sql("select s.id, s.major_id, m.name from students s INNER JOIN majors m ON s.major_id = m.id ").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash.to_json
  end

  def self.get_fee
    hash = {}
    find_by_sql("select f.major_id,s.id, s.major_id, p.student_id,(f.fee1+f.fee2+f.fee3+f.other) fee from fee_stds f INNER JOIN proces p INNER JOIN students s ON p.student_id = s.id AND f.major_id = s.major_id ").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["fee"]
    end
    return hash.to_json
  end

  def self.get_campus
    hash = {}
    find_by_sql("select s.id, s.major_id, m.campus from students s INNER JOIN majors m ON s.major_id = m.id").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["campus"]
    end
    return hash.to_json
  end

  def self.get_beds
    hash = {}
    find_by_sql("select a.student_id, a.number,b.name building_name,c.name room_name  from beds a INNER JOIN rooms b INNER JOIN buildings c INNER JOIN proces d ON d.student_id = a.student_id ").each do |row|
      attrs = row.attributes
      hash[attrs["student_id"]] = attrs["building_name"].to_s + attrs["room_name"].to_s + attrs["number"].to_s
    end
    return hash.to_json
  end

  def self.signup_done
    proces = Proce.find(:all, :conditions => ["step1 = ?", true])
    proces.each do |p|
      student = Student.find(p.student_id)
      student.update_attributes(:confirm => true, :confirm_date => Time.now)
    end
  end
end
