class AddSignupNumberToStudents < ActiveRecord::Migration
  def self.up
    add_column :students, :signup_number, :string
  end

  def self.down
    remove_column :students, :signup_number
  end
end
