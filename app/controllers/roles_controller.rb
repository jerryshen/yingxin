class RolesController < ApplicationController
  #  protect_from_forgery :except => :index
  #  skip_before_filter :verify_authenticity_token
  # GET /roles
  # GET /roles.xml
  def index
    @roles = Role.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @roles }
      format.json { render :text => get_json }
    end
  end

  # GET /roles/1
  # GET /roles/1.xml
  def show
    @role = Role.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @role }
    end
  end

  # GET /roles/new
  # GET /roles/new.xml
  def new
    @role = Role.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @role }
    end
  end

  # GET /roles/1/edit
  def edit
    @role = Role.find(params[:id])
  end

  # POST /roles
  # POST /roles.xml
  def create
    @role = Role.new(params[:role])

    respond_to do |format|
      if @role.save
        format.html { redirect_to(@role) }
        format.xml  { render :xml => @role, :status => :created, :location => @role }
        format.json { render :text => '{status: "success", message: "成功创建角色！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@role.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /roles/1
  # PUT /roles/1.xml
  def update
    @role = Role.find(params[:id])

    respond_to do |format|
      if @role.update_attributes(params[:role])
        format.html { redirect_to(@role) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新角色！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@role.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    @role = Role.find(params[:id])
    @role.destroy

    respond_to do |format|
      format.html { redirect_to(roles_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end
  
  private
  def get_json
    load_page_data

    if(params[:search_name] && params[:search_name].to_s!='')
      @roles = Role.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=> @pagesize,:page => params[:page] || 1)
      count = Role.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @roles = Role.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = Role.count
    end
    return render_json(@roles,count)
  end
end
