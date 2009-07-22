class CreateProces < ActiveRecord::Migration
  def self.up
    create_table :proces do |t|
      t.references :student
      t.boolean :step1, :default => false
      t.boolean :step2, :default => false
      t.boolean :step3, :default => false
      t.boolean :step4, :default => false
      t.boolean :step5, :default => false
      t.boolean :step6, :default => false
      t.boolean :step7, :default => false
      t.datetime :step1_date
      t.datetime :step2_date
      t.datetime :step3_date
      t.datetime :step4_date
      t.datetime :step5_date
      t.datetime :step6_date
      t.datetime :step7_date
      t.timestamps
    end
    add_index :proces, :student_id
  end

  def self.down
    drop_table :proces
  end
end
