require 'faster_csv'
class FeeTemp < ActiveRecord::Base
  def self.import(csvfile)
    n=0
    FasterCSV.parse(csvfile,:headers=>true)do |row|   
      temp = self.new  
      temp.f1 = row[1]   
      temp.f2 = row[4]   
      temp.f3 = row[5]   
      temp.f4 = row[9]   
      temp.save!   
      n=n+1
      GC.start if n%50==0    #GC 是Rails 的垃圾收集器的类(Garbage Collector,GC)
    end
    return n
  end

end
