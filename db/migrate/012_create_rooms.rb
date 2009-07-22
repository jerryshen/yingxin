class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.references :building
      t.references :info_class
      t.references :student
      t.string :name
      t.integer :bed_count
      t.string :phone
      t.integer :room_type

      t.timestamps
    end
    add_index :rooms, :building_id
    add_index :rooms, :info_class_id
    add_index :rooms, :student_id
  end

  def self.down
    drop_table :rooms
  end
end
