class Temp < ActiveRecord::Base
  
  #import major data to majors
  def self.import_to_majors
    arr = []
    Temp.all.each do |t|
      arr.push(t.f20)
    end
    majors = arr.uniq
    majors.each do |t|
      Major.create(:name => t)
    end
  end

  #import stu data to students
  def self.import_to_students
    students = Temp.all
    if students.blank?
      return "no data"
    else
      students.each do |d|

        gender = d.f3 == "男" ? "m" : "f"
        major_id = Major.find_by_name(d.f20).id

        Student.create(
          :name         => d.name,
          :can_number   => d.f1,
          :exa_number   => d.f2,
          :gender       => gender,
          :birthday     => d.f4.to_time,
          :h_score      => d.f5,
          :r_score      => d.f6,
          :polity       => d.f7,
          :nation       => d.f8,
          :stu_type     => d.f9,
          :gra_type     => d.f10,
          :school_code  => d.f11,
          :school_name  => d.f12,
          :region_code  => d.f13,
          :region_name  => d.f14,
          :id_number    => d.f15,
          :rec_addr    => d.f16,
          :post_code    => d.f17,
          :phone        => d.f18,
          :receiver     => d.f19,
          :major_id     => major_id,
          :edu_length   => d.f21)
      end
    end
  end
end
