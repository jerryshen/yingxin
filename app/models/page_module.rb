class PageModule < ActiveRecord::Base
  #mapping
  has_many :pages, :class_name  => 'Page'

  #validation
  validates_presence_of :name
  validates_uniqueness_of :name

  #find pages belongs to a module
  def self.find_pages_by_module_id(module_id)
    self.find(module_id).pages
  end

  #列表中实现ID和name的切换显示
  def self.to_json
    hash = {}
    find_by_sql("select id,name from page_modules").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash.to_json
  end

  def pages_of_user(user)
    self.pages.collect{ |p| p.accessable? user }
  end
end
