class CreateClassStudents < ActiveRecord::Migration
  def self.up
    create_table :class_students do |t|
      t.references :info_class
      t.references :student

      t.timestamps
    end
    add_index :class_students, :info_class_id
    add_index :class_students, :student_id
  end

  def self.down
    drop_table :class_students
  end
end
