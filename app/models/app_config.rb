class AppConfig < ActiveRecord::Base
  #validations
  validates_presence_of :key, :value


  #APP CONFIG get value by key
  def self.get(key)
    config = find_by_key(key)
    return config.nil? ? "" : config.value
  end

  def self.set(key,value)
    config = find_by_key(key)
    if config.nil?
      config = new({:key=>key})
    end
    config.value = value
    config.save
  end
end
