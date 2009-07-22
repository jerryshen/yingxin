class BedAssigningController < ApplicationController
  protect_from_forgery :only => :index
  def index
    
  end
  
  def list_room
    building_id = params[:building_id]
    unless building_id.blank?
      @building = Building.find(building_id)
      unless @building.nil?
        rooms = @building.rooms
        unless rooms.empty?
          rooms.sort!{|x,y| x.name.to_i <=> y.name.to_i }.reverse!
          @floors = [[]]
          curr_floor = @floors[0]
          name = rooms[0].name
          curr_floor_no = (name.length == 3 ? name[0..0] : name[0..1])
          rooms.each do | room |
            no = (room.name.length == 3 ? room.name[0..0] :  room.name[0..1])
            if(no == curr_floor_no)
              curr_floor << room
            else
              curr_floor.sort!{|x,y| x.name.to_i <=> y.name.to_i }
              curr_floor = [room]
              @floors << curr_floor
              curr_floor_no = no
            end
          end
          curr_floor.sort!{|x,y| x.name.to_i <=> y.name.to_i }
          render :layout => false          
        end
      else
        render :text => "该宿舍楼已经不存在了"
      end
    end    
  end
  
  def room_info
    room_id = params[:room_id]
    unless room_id.blank?
      @room = Room.find(room_id)
      unless @room.nil?
        @beds = Array.new(@room.bed_count)
        @room.beds.each do |bed|
          @beds[bed.name.to_i - 1] = bed
        end
        render :layout => false
      else
        render :text => "该宿舍未登记"
      end
    end
  end
end
