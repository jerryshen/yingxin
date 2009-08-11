class AddRemitToProces < ActiveRecord::Migration
  def self.up
    add_column :proces, :remit, :boolean, :default => false
    add_column :proces, :remit_date, :datetime
    add_column :proces, :leave, :boolean, :default => false
    add_column :proces, :leave_date, :datetime
  end

  def self.down
    remove_column :proces, :remit
    remove_column :proces, :remit_date
    remove_column :proces, :leave
    remove_column :proces, :leave_date
  end
end
