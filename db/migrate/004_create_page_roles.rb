class CreatePageRoles < ActiveRecord::Migration
  def self.up
    create_table :page_roles do |t|
      t.references :page
      t.references :role

      t.timestamps
    end
    add_index :page_roles, :page_id
    add_index :page_roles, :role_id
  end

  def self.down
    drop_table :page_roles
  end
end
