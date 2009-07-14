class CreateStep3s < ActiveRecord::Migration
  def self.up
    create_table :step3s do |t|
      t.references :student
      t.boolean :pass, :default => false
      t.datetime :date

      t.timestamps
    end
    add_index :step3s, :student_id
  end

  def self.down
    drop_table :step3s
  end
end
