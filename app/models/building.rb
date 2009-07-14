class Building < ActiveRecord::Base
  has_many :rooms
  has_many :students

  def rooms_to_json
    dep_rooms = self.rooms
    ar_rooms = dep_rooms.collect do |row|
      {:id => row.id, :name => row.name}
    end
    ar_rooms.to_json
  end
end
