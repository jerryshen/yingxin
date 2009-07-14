class CreatePageModules < ActiveRecord::Migration
  def self.up
    create_table :page_modules  do |t|
      t.string :name
      t.string :icon
      t.integer :index
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :page_modules
  end
end
