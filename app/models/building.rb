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
  
  #生成宿舍和床位
  def genarate_room(floor_count, per_floor_room_count, room_type, bed_count)
    gen_count = 0
    floor_count.times do |f_no|
      per_floor_room_count.times do |r_no|
        begin
          room = self.rooms.new
          room.name = "#{f_no + 1}#{(r_no + 1) < 10 ? "0" : ""}#{r_no + 1}"
          room.room_type = room_type
          room.bed_count = bed_count
          if room.save
            gen_count += 1
            room.genarate_bed
          end
        rescue => error
          puts error
        end
      end
    end
    return gen_count
  end  

  def update_room(update_rooms, room_type, bed_count, info_class_id)
    result = {:count => 0, :error => []}
    changes = {}
    unless bed_count.blank?
      changes[:bed_count] = bed_count
    end

    unless room_type.blank?
      changes[:room_type] = room_type
    end

    unless info_class_id.blank?
      changes[:info_class_id] = info_class_id
    end

    update_rooms.each do |id|
      r = self.rooms.find(id)
      unless r.nil?
        begin
          r.update_attributes(changes) 
          result[:count] += 1
        rescue => error
          result[:error].push(error.to_s)
        end
      end
    end
    return result
  end
end
