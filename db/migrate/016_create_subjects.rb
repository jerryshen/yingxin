class CreateSubjects < ActiveRecord::Migration
  def self.up
    create_table :subjects do |t|
      t.string :name
      t.integer :index
      t.string :addr
      t.string :department
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :subjects
  end
end
