#+------------+----------+------+-----+---------+----------------+
#| Field      | Type     | Null | Key | Default | Extra          |
#+------------+----------+------+-----+---------+----------------+
#| id         | int(11)  | NO   | PRI | NULL    | auto_increment |
#| page_id    | int(11)  | YES  | MUL | NULL    |                |
#| role_id    | int(11)  | YES  | MUL | NULL    |                |
#| created_at | datetime | YES  |     | NULL    |                |
#| updated_at | datetime | YES  |     | NULL    |                |
#+------------+----------+------+-----+---------+----------------+
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
