module FileUploadUtil
  def self.save_file(file,save_dir,save_name)
    self.make_upload_dir(save_dir)
    File.open(save_dir + "/" + save_name,"wb") do |f|
      f.write(file.read)
    end
  end

  def self.make_timestamp_file_name(file)
    now = Time.now
    return now.strftime("%Y_%m_%d_%H_%M_%S_") + now.usec.to_s  +  self.get_file_ex_name(file)
  end

  def self.make_upload_dir(dir)
    unless File.exists? dir
      FileUtils.mkpath dir
      FileUtils.chmod 0770,dir
    end
  end
  
  def self.get_file_ex_name(file)
    return "." + file.original_filename.sub(/^.*\./,'')
  end  
end  
