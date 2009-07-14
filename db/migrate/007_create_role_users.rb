class CreateRoleUsers < ActiveRecord::Migration
  def self.up
    create_table :role_users do |t|
      t.references :user
      t.references :role

      t.timestamps
    end
    add_index :role_users, :user_id
    add_index :role_users, :role_id
  end

  def self.down
    drop_table :role_users
  end
end
