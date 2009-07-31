class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages  do |t|
      t.string :name
      t.text :function
      t.string :url
      t.integer :index, :default => 0
      t.string :icon
      t.references :page_module
      t.boolean :hidden, :default => false

      t.timestamps
    end
    add_index :pages, :page_module_id
  end

  def self.down
    drop_table :pages
  end
end
