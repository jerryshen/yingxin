class AddIndexToDepartments < ActiveRecord::Migration
  def self.up
    add_column :departments, :index, :integer
  end

  def self.down
    remove_column :departments, :index
  end
end
