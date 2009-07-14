class UsersController < ApplicationController
  protect_from_forgery :except => [:update_theme, :change_my_password]
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
      format.json { render :text => get_json }
      format.csv { export_csv(@users,
          { :id => "id",:name => "姓名",:login_id => "账号", :department_id => "系部",
            :td_belongs_id => "教学所属系部", :gender => "性别", :title_id => "职称",
            :position_id => "职务", :birthday => "生日", :id_card => "身份证号",
            :is_nature => "是否入编", :is_retired => "是否离退休" }, "教职工数据.csv") }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
        format.json { render :text => '{status: "success", message: "成功创建教职工！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@user.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新教职工！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@user.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def my_profile
  end

  def change_my_password
  end

  def try_to_change_password
    if @current_user
      if @current_user.change_password(params[:old_password],params[:new_password])
        flash[:notice] = "密码已经成功修改"
      else
        flash[:notice] = "请检查您的密码"
      end
    end
    render :action => 'change_my_password'
  end

  def update_theme
    if request.post?
      if @current_user.update_theme(params[:theme])
        render :text => "true"
      else
        render :text => "false"
      end
    end
  end

  private
  def get_json
    load_page_data
    conditions = '1=1'
    condition_values = []
    if(!params[:search_name].blank?)
      conditions += " AND name like ? "
      condition_values << "%#{params[:search_name]}%"
    end

    if(!params[:search_department_id].blank?)
      conditions += " AND department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(!params[:search_title_id].blank?)
      conditions += " AND title_id = ? "
      condition_values << params[:search_title_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @users = User.paginate(:order =>"id DESC", :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = User.count(:conditions => option_conditions)
    else
      @users = User.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = User.count
    end
    return render_json(@users,count)
  end

end
