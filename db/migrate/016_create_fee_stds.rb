class CreateFeeStds < ActiveRecord::Migration
  def self.up
    create_table :fee_stds do |t|
      t.references :major
      t.float :fee1,  :default => 0
      t.float :fee2,  :default => 0
      t.float :fee3,  :default => 0
      t.float :other, :default => 0

      t.timestamps
    end
    add_index :fee_stds, :major_id
  end

  def self.down
    drop_table :fee_stds
  end
end
