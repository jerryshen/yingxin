class RoleUser < ActiveRecord::Base
  #mapping
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :role, :class_name => 'Role', :foreign_key => 'role_id'

  #validations
  validates_presence_of :role_id, :user_id

  #find all users in one role by id
  def self.find_all_users_in_role(role_id)
    Role.find_by_id(role_id).users
  end

  #find users by name
  def self.find_users_by_name(name)
    User.find(:all, :conditions => ["name like ?","%#{name}%"])
  end
end
