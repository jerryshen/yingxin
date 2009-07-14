class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.references :building
      t.string :name
      t.integer :beds
      t.string :phone
      t.integer :room_type

      t.timestamps
    end
    add_index :rooms, :building_id
  end

  def self.down
    drop_table :rooms
  end
end
