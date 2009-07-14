require 'uri'
class Page < ActiveRecord::Base
  #mapping
  belongs_to :page_module, :class_name => 'PageModule', :foreign_key => 'page_module_id'
  has_many :page_roles
  has_many :roles, :through => :page_roles, :class_name => 'Role', :foreign_key => 'role_id'

  #validations
  validates_presence_of :name, :page_module_id, :url
  validates_uniqueness_of :url

  #find roles who can view the page by page name.
  def self.find_roles_by_name(name)
    page = self.find(:all, :conditions => ["name = ?",name])
    unless page.nil?
        page.roles
    end
  end

  def self.find_by_url(url)
    uri = URI.parse(url)
    path = uri.path
    return self.find(:first,:conditions => ["url = ?", path])
  end

  def accessable_users
    users = []
    self.roles.each{ |r| users += r.users }
    return users
  end

  #列表中实现ID和name的切换显示
  def self.to_json
    hash = {}
    find_by_sql("select id,name from pages").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash.to_json
  end

  def self.accessable?(url,user)
    page = self.find_by_url(url)
    unless page.nil?
      page.accessable? user
    else
      #raise "未定义路径为:#{path}的功能页面"
      true #未加入到权限管理的页面默认可以访问
    end
  end

  #用户是否有访问本页面的权限
  def accessable? user
   self.accessable_users.include? user 
  end
end
