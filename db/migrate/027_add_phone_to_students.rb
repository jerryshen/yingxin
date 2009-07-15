class AddPhoneToStudents < ActiveRecord::Migration
  def self.up
    add_column :students, :phone, :string
  end

  def self.down
    remove_column :students, :phone
  end
end
