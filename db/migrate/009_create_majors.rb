class CreateMajors < ActiveRecord::Migration
  def self.up
    create_table :majors do |t|
      t.references :department
      t.string :name

      t.timestamps
    end
    add_index :majors, :department_id
  end

  def self.down
    drop_table :majors
  end
end
