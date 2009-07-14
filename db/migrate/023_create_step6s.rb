class CreateStep6s < ActiveRecord::Migration
  def self.up
    create_table :step6s do |t|
      t.references :student
      t.boolean :pass, :default => false
      t.datetime :date

      t.timestamps
    end
    add_index :step6s, :student_id
  end

  def self.down
    drop_table :step6s
  end
end
