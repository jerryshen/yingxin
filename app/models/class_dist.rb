class ClassDist

  #dist classes
  def self.dispatch(major_id)
    boys = Student.find(:all, :conditions => ["gender= 'm'  and major_id=?", major_id], :order => "h_score DESC").select{|x| x.info_class_id == nil}
    girls = Student.find(:all, :conditions => ["gender= 'f' AND major_id=?", major_id], :order => "h_score DESC").select{|x| x.info_class_id == nil}
    classes = Major.find(major_id).info_classes

    i = 0
    count = classes.count
    for i in 0..count
    girls.each do |g|
      g.update_attributes(:info_class_id => classes[i].id)
      i +=1
      if(i==count)
        i=0
      end
    end


    boys.each do |b|
      b.update_attributes(:info_class_id => classes[i].id)
      i +=1
      if(i==count)
        i=0
      end
    end
    end

  end
end
