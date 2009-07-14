class CreateStep4s < ActiveRecord::Migration
  def self.up
    create_table :step4s do |t|
      t.references :student
      t.boolean :pass, :default => false
      t.datetime :date

      t.timestamps
    end
    add_index :step4s, :student_id
  end

  def self.down
    drop_table :step4s
  end
end
