class Building < ActiveRecord::Base
  has_many :rooms
  has_many :students

  before_destroy :destroyable

  def destroyable
    raise "can't destroy" if !self.rooms.blank?
  end

  def rooms_to_json
    dep_rooms = self.rooms
    ar_rooms = dep_rooms.collect do |row|
      {:id => row.id, :name => row.name}
    end
    ar_rooms.to_json
  end

  def self.to_json
    hash = {}
    find_by_sql("select id,name from buildings").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash.to_json
  end
end
