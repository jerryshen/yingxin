
require 'file_upload_util'
class FeeTemp < ActiveRecord::Base
  def self.import(csvfile)
    file_path = upload_to_temp_dir(csvfile)
    result = 0
    begin
      result = self.parse_by_csv(file_path)
    rescue => error
      raise error
    ensure
      if File.exist?(file_path)
        File.delete(file_path)
      end
    end
    return result
  end


  private
  def self.parse_by_csv(csvfile)
    require 'csv'
    n=0
    File.open(csvfile, 'r') do |f|
      CSV::Reader.parse(f) do |row|
        if n > 0
          # puts row[1].data << " " << row[4].data << " " << row[5].data << " " << row[9].data
          temp = self.new
          temp.f1 = row[1]
          temp.f2 = row[4].gsub!(',','').to_f
          temp.f3 = row[6].gsub!(',','').to_f
          temp.f4 = row[9].gsub!(',','').to_f
          temp.save!   
        end
        n=n+1
        GC.start if n%50 == 0
      end
    end
    return n
  end
  
  def self.parse_by_fastercsv(csvfile)
    require 'faster_csv'
    n=0
    FasterCSV.foreach(csvfile,:headers=>true,:encoding => "gb2312",:quote_char => '"') do |row|
      temp = self.new
      temp.f1 = row[1]
      temp.f2 = row[4]
      temp.f3 = row[6]
      temp.f4 = row[9]   
      temp.save!   
      n=n+1
      GC.start if n%50==0    #GC 是Rails 的垃圾收集器的类(Garbage Collector,GC)
    end
    return n
  end

  def self.upload_to_temp_dir(file)
    ext_name = FileUploadUtil.get_file_ex_name(file)
    if(ext_name == ".csv")
      save_name = FileUploadUtil.make_timestamp_file_name(file)
      save_dir = RAILS_ROOT + '/tmp/import_csv_files'
      FileUploadUtil.save_file(file,save_dir,save_name)
    else
      raise "请上传csv文件(扩展名为.csv)"
    end
    return save_dir + "/" + save_name
  end
end
