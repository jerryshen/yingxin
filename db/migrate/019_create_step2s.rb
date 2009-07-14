class CreateStep2s < ActiveRecord::Migration
  def self.up
    create_table :step2s do |t|
      t.references :student
      t.boolean :pass, :default => false
      t.datetime :date
      t.references :major

      t.timestamps
    end
    add_index :step2s, :student_id
    add_index :step2s, :major_id
  end

  def self.down
    drop_table :step2s
  end
end
