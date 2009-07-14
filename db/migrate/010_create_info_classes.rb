class CreateInfoClasses < ActiveRecord::Migration
  def self.up
    create_table :info_classes do |t|
      t.references :major
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :info_classes
  end
end
