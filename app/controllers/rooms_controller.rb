class RoomsController < ApplicationController
  # GET /rooms
  # GET /rooms.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rooms }
      format.json { render :text => get_json }
    end
  end
  
  # GET /rooms/1
  # GET /rooms/1.xml
  def show
    @room = Room.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @room }
    end
  end
  
  # GET /rooms/new
  # GET /rooms/new.xml
  def new
    @room = Room.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @room }
    end
  end
  
  # GET /rooms/1/edit
  def edit
    @room = Room.find(params[:id])
  end
  
  # POST /rooms
  # POST /rooms.xml
  def create
    @room = Room.new(params[:room])
    
    respond_to do |format|
      if @room.save
        format.html { redirect_to(@room) }
        format.xml  { render :xml => @room, :status => :created, :location => @room }
        format.json { render :text => '{status: "success", message: "成功添加宿舍！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @room.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@room.errors.full_messages.to_json}}"}
      end
    end
  end
  
  # PUT /rooms/1
  # PUT /rooms/1.xml
  def update
    @room = Room.find(params[:id])
    
    respond_to do |format|
      if @room.update_attributes(params[:room])
        format.html { redirect_to(@room) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新宿舍！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @room.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@room.errors.full_messages.to_json}}"}
      end
    end
  end
  
  # DELETE /rooms/1
  # DELETE /rooms/1.xml
  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    
    respond_to do |format|
      format.html { redirect_to(rooms_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end
  
  private
  def get_json
    load_page_data
    if(params[:search_name] && params[:search_name].to_s!='')
      @rooms = Room.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=> @pagesize,:page => params[:page] || 1)
      count = Room.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @rooms = Room.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = Room.count
    end
    return render_json(@rooms,count)
  end
end
