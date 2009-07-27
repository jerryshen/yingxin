class BuildingsController < ApplicationController
  protect_from_forgery :except => [:rooms_to_json, :genarate_room]
  # GET /buildings
  # GET /buildings.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @buildings }
      format.json { render :text => get_json }
    end
  end
  
  # GET /buildings/1
  # GET /buildings/1.xml
  def show
    @building = Building.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @building }
    end
  end
  
  # GET /buildings/new
  # GET /buildings/new.xml
  def new
    @building = Building.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @building }
    end
  end
  
  # GET /buildings/1/edit
  def edit
    @building = Building.find(params[:id])
  end
  
  # POST /buildings
  # POST /buildings.xml
  def create
    @building = Building.new(params[:building])
    
    respond_to do |format|
      if @building.save
        format.html { redirect_to(@building) }
        format.xml  { render :xml => @building, :status => :created, :location => @building }
        format.json { render :text => '{status: "success", message: "成功添加宿舍大楼！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @building.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@building.errors.full_messages.to_json}}"}
      end
    end
  end
  
  # PUT /buildings/1
  # PUT /buildings/1.xml
  def update
    @building = Building.find(params[:id])
    
    respond_to do |format|
      if @building.update_attributes(params[:building])
        format.html { redirect_to(@building) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新宿舍大楼！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @building.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@building.errors.full_messages.to_json}}"}
      end
    end
  end
  
  # DELETE /buildings/1
  # DELETE /buildings/1.xml
  def destroy
    @building = Building.find(params[:id])
    @building.destroy
    
    respond_to do |format|
      format.html { redirect_to(buildings_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end
  
  def genarate_room
    building = Building.find(params[:building_id])
    unless building.nil?
      begin
        result = {:status => "success"}
        count = building.genarate_room(params[:floor_count].to_i, params[:room_count].to_i, params[:room_type].to_i, params[:bed_count].to_i)
        result[:msg] = "共生成#{count}个宿舍"
      rescue => error
        result = {:status => "fail", :msg => error.to_s}
      end
      render :json => result  
    end
  end
  
  def rooms_to_json
    if request.post?
      building = Building.find(params[:id])
      if(building)
        render :text => building.rooms_to_json
      end
    end
  end
  
  private
  def get_json
    load_page_data
    if(params[:search_name] && params[:search_name].to_s!='')
      @buildings = Building.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=> @pagesize,:page => params[:page] || 1)
      count = Building.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @buildings = Building.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = Building.count
    end
    return render_json(@buildings,count)
  end
end
