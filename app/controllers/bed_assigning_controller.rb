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
          @beds[bed.number - 1] = bed
        end
        render :layout => false
      else
        render :text => "该宿舍未登记"
      end
    end
  end

  def update_room
    room_type = params[:room_type]
    bed_count = params[:bed_count]
    info_class_id = params[:info_class_id]
    rooms = params[:rooms].split(',')
    building = Building.find(params[:building_id])
    if building
      result = building.update_room(rooms, room_type, bed_count, info_class_id) 
      render :text => result.to_json
    end
  end

  def update_master
    room = Room.find(params[:room_id])
    if room
      begin
        room.update_attributes(:student_id => params[:master_id])
        render :text => "成功设置舍长"
      rescue => error
        render :text => error
      end
    end
  end

  def update_phone
    room = Room.find(params[:room_id])
    if room
      begin
        room.update_attributes(:phone => params[:phone])
        render :text => "成功设置宿舍电话"
      rescue => error
        render :text => error
      end
    end
  end

  def update_room_type
    room = Room.find(params[:room_id])
    if room
      begin
        room.update_attributes(:room_type => params[:room_type])
        render :text => "成功设置宿舍类别"
      rescue => error
        render :text => error
      end
    end
  end
end
