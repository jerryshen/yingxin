class CreateStep5s < ActiveRecord::Migration
  def self.up
    create_table :step5s do |t|
      t.references :student
      t.boolean :pass, :default => false
      t.datetime :date

      t.timestamps
    end
    add_index :step5s, :student_id
  end

  def self.down
    drop_table :step5s
  end
end
