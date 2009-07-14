class CreateStep7s < ActiveRecord::Migration
  def self.up
    create_table :step7s do |t|
      t.references :student
      t.boolean :pass, :default => false
      t.datetime :date

      t.timestamps
    end
    add_index :step7s, :student_id
    add_column :students, :confirm, :boolean, :default => false
    add_column :students, :confirm_date, :datetime
  end

  def self.down
    drop_table :step7s
    remove_column :students, :confirm
    remove_column :students, :confirm_date
  end
end
