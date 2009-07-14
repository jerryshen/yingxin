class PageModulesController < ApplicationController
  #  protect_from_forgery :except => :index
  #  skip_before_filter :verify_authenticity_token
  # GET /page_modules
  # GET /page_modules.xml
  def index
    @page_modules = PageModule.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @page_modules }
      format.json { render :text => get_json }
    end
  end

  # GET /page_modules/1
  # GET /page_modules/1.xml
  def show
    @page_module = PageModule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page_module }
    end
  end

  # GET /page_modules/new
  # GET /page_modules/new.xml
  def new
    @page_module = PageModule.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page_module }
    end
  end

  # GET /page_modules/1/edit
  def edit
    @page_module = PageModule.find(params[:id])
  end

  # POST /page_modules
  # POST /page_modules.xml
  def create
    @page_module = PageModule.new(params[:page_module])

    respond_to do |format|
      if @page_module.save
        format.html { redirect_to(@page_module) }
        format.xml  { render :xml => @page_module, :status => :created, :location => @page_module }
        format.json { render :text => '{status: "success", message: "成功创建页面模块！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page_module.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@page_module.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /page_modules/1
  # PUT /page_modules/1.xml
  def update
    @page_module = PageModule.find(params[:id])

    respond_to do |format|
      if @page_module.update_attributes(params[:page_module])
        format.html { redirect_to(@page_module) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新页面模块！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page_module.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@page_module.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /page_modules/1
  # DELETE /page_modules/1.xml
  def destroy
    @page_module = PageModule.find(params[:id])
    @page_module.destroy

    respond_to do |format|
      format.html { redirect_to(page_modules_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end
  
  private
  def get_json
    load_page_data
    if(params[:search_name] && params[:search_name].to_s!='')
      @page_modules = PageModule.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=> @pagesize,:page => params[:page] || 1)
      count = PageModule.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @page_modules = PageModule.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = PageModule.count
    end
    return render_json(@page_modules,count)
  end
end
