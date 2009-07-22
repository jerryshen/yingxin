class CreateBeds < ActiveRecord::Migration
  def self.up
    create_table :beds do |t|
      t.integer :number
      t.references :room
      t.references :student

      t.timestamps
    end
    add_index :beds, :room_id
    add_index :beds, :student_id
  end

  def self.down
    drop_table :beds
  end
end
