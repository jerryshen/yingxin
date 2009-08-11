class AddCampusToMajors < ActiveRecord::Migration
  def self.up
    add_column :majors, :campus, :string
  end

  def self.down
    remove_column :majors, :campus
  end
end
