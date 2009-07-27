class PageRolesController < ApplicationController
  #	protect_from_forgery :except => :index
  #  skip_before_filter :verify_authenticity_token
  # GET /page_roles
  # GET /page_roles.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @page_roles }
      format.json { render :text => get_json }
    end
  end

  # GET /page_roles/1
  # GET /page_roles/1.xml
  def show
    @page_role = PageRole.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page_role }
    end
  end

  # GET /page_roles/new
  # GET /page_roles/new.xml
  def new
    @page_role = PageRole.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page_role }
    end
  end

  # GET /page_roles/1/edit
  def edit
    @page_role = PageRole.find(params[:id])
  end

  # POST /page_roles
  # POST /page_roles.xml
  def create
    @page_role = PageRole.new(params[:page_role])

    respond_to do |format|
      if @page_role.save
        format.html { redirect_to(@page_role) }
        format.xml  { render :xml => @page_role, :status => :created, :location => @page_role }
        format.json { render :text => '{status: "success", message: "成功创建页面－角色关系！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page_role.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@page_role.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /page_roles/1
  # PUT /page_roles/1.xml
  def update
    @page_role = PageRole.find(params[:id])

    respond_to do |format|
      if @page_role.update_attributes(params[:page_role])
        format.html { redirect_to(@page_role) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改页面－角色关系！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page_role.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@page_role.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /page_roles/1
  # DELETE /page_roles/1.xml
  def destroy
    @page_role = PageRole.find(params[:id])
    @page_role.destroy

    respond_to do |format|
      format.html { redirect_to(page_roles_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end
  
  private
  def get_json
    load_page_data

    conditions = '1=1'
    condition_values = []
    if(!params[:search_page_id].blank?)
      conditions += " AND page_id = ? "
      condition_values << params[:search_page_id]
    end

    if(!params[:search_role_id].blank?)
      conditions += " AND role_id = ? "
      condition_values << params[:search_role_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @page_roles = PageRole.paginate(:order =>"id DESC", :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = PageRole.count(:conditions => option_conditions)
    else
      @page_roles = PageRole.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = PageRole.count
    end
    return render_json(@page_roles,count)
  end
  
 
end

