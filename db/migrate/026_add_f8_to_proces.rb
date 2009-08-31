class AddF8ToProces < ActiveRecord::Migration
  def self.up
    add_column :proces, :step8, :boolean, :default => false
    add_column :proces, :step8_date, :datetime
  end

  def self.down
    remove_column :proces, :step8
    remove_column :proces, :step8_date
  end
end
