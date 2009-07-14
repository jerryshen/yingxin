class Role < ActiveRecord::Base
  #mapping
  has_many :page_roles
  has_many :pages, :through => :page_roles, :class_name => 'Page', :foreign_key => 'page_id'

  has_many :role_users
  has_many :users, :through => :role_users, :class_name => 'User', :foreign_key => 'user_id'
  
  #validations
  validates_presence_of :name
  validates_uniqueness_of :name

  #列表中实现ID和name的切换显示
  def self.to_json
    hash = {}
    find_by_sql("select id,name from roles").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash.to_json
  end
end
