class ClassDist

  #dist classes
  def dist(major_id, groups)
    all_students = Major.find(major_id).students
    ar_males     = all_students.reject{|s| s.gender != 'm'}.sort_by { |s| s.h_score }.reverse
    ar_females   = all_students.reject{|s| s.gender != 'f'}.sort_by { |s| s.h_score }.reverse
    arr = []
    case groups
    when 1
      arr << ar_females << ar_males
      return arr
    when 2
      arr1 = arr2 =[]
      arr1 << ar_females[0]
    end
  end
end
