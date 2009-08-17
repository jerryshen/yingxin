class ChangeTypePolity < ActiveRecord::Migration
  def self.up
    change_column :students, :polity, :string
  end

  def self.down
    change_column :students, :polity, :integer
  end
end
