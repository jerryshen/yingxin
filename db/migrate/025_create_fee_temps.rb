class CreateFeeTemps < ActiveRecord::Migration
  def self.up
    create_table :fee_temps do |t|
      t.string :f1
      t.float :f2, :default => 0
      t.float :f3, :default => 0
      t.float :f4, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :fee_temps
  end
end
