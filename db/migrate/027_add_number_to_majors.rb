class AddNumberToMajors < ActiveRecord::Migration
  def self.up
    add_column :majors, :number, :string
  end

  def self.down
    remove_column :majors, :number
  end
end
