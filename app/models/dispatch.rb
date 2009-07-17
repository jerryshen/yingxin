class Dispatch

  #dist classes
  def self.dispatch(major_id)
    boys = Student.find(:all, :conditions => {:gender => 'm',  :major_id => major_id, :info_class_id => nil}, :order => "h_score DESC")
    girls = Student.find(:all, :conditions => {:gender => 'f',  :major_id => major_id, :info_class_id => nil}, :order => "h_score DESC")
    classes = Major.find(major_id).info_classes
    sendto_class(classes, boys)
    sendto_class(classes, girls)
    return true
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
