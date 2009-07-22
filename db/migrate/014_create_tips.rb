class CreateTips < ActiveRecord::Migration
  def self.up
    create_table :tips do |t|
      t.string :title
      t.references :user
      t.text :content
      t.boolean :top, :default => false
      t.boolean :hidden, :default => false

      t.timestamps
    end
    add_index :tips, :user_id
  end

  def self.down
    drop_table :tips
  end
end
