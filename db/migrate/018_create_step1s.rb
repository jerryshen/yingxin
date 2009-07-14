class CreateStep1s < ActiveRecord::Migration
  def self.up
    create_table :step1s do |t|
      t.references :student
      t.boolean :pass, :default => false
      t.datetime :date

      t.timestamps
    end
    add_index :step1s, :student_id
  end

  def self.down
    drop_table :step1s
  end
end
