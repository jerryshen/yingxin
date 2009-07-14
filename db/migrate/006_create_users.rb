class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.references :department
      t.string :gender
      t.string :login_id
      t.string :password
      t.string :theme


      t.timestamps
    end
    add_index :users, :department_id
  end

  def self.down
    drop_table :users
  end
end
