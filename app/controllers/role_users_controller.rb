class RoleUsersController < ApplicationController
  # GET /role_users
  # GET /role_users.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @role_users }
      format.json { render :text => get_json }
    end
  end

  # GET /role_users/1
  # GET /role_users/1.xml
  def show
    @role_user = RoleUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @role_user }
    end
  end

  # GET /role_users/new
  # GET /role_users/new.xml
  def new
    @role_user = RoleUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @role_user }
    end
  end

  # GET /role_users/1/edit
  def edit
    @role_user = RoleUser.find(params[:id])
  end

  # POST /role_users
  # POST /role_users.xml
  def create
    @role_user = RoleUser.new(params[:role_user])

    respond_to do |format|
      if @role_user.save
        format.html { redirect_to(@role_user) }
        format.xml  { render :xml => @role_user, :status => :created, :location => @role_user }
        format.json { render :text => '{status: "success",message: "成功创建角色－用户关系！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @role_user.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@role_user.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /role_users/1
  # PUT /role_users/1.xml
  def update
    @role_user = RoleUser.find(params[:id])

    respond_to do |format|
      if @role_user.update_attributes(params[:role_user])
        format.html { redirect_to(@role_user) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success",message: "成功更新角色－用户关系！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @role_user.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@role_user.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /role_users/1
  # DELETE /role_users/1.xml
  def destroy
    @role_user = RoleUser.find(params[:id])
    @role_user.destroy

    respond_to do |format|
      format.html { redirect_to(role_users_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end
  
  private
  def get_json
    load_page_data

    conditions = '1=1'
    condition_values = []
    if(params[:search_name] && params[:search_name] != '')
      if user = User.find_by_name(params[:search_name])
        user_id = user.id
      else
        user_id = 0
      end
      conditions += " AND user_id = ? "
      condition_values << user_id
    end

    if(params[:search_role_id] && params[:search_role_id] != '')
      conditions += " AND role_id = ? "
      condition_values << params[:search_role_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @role_users = RoleUser.paginate(:order =>"id DESC", :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = RoleUser.count(:conditions => option_conditions)
    else
      @role_users = RoleUser.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = RoleUser.count
    end
    return render_json(@role_users,count)
  end
  
end

