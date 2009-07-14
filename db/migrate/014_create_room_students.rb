class CreateRoomStudents < ActiveRecord::Migration
  def self.up
    create_table :room_students do |t|
      t.references :room
      t.string :bed
      t.references :student

      t.timestamps
    end
    add_index :room_students, :room_id
    add_index :room_students, :student_id
  end

  def self.down
    drop_table :room_students
  end
end
