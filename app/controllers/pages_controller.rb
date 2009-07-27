class PagesController < ApplicationController
  # GET /pages
  # GET /pages.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
      format.json { render :text => get_json }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = Page.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to(@page) }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
        format.json { render :text => '{status: "success", message: "成功创建页面！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@page.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to(@page) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新页面！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@page.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def hide
    @page = Page.find(params[:id])
    if @page.update_attributes(:hidden => !@page.hidden)
      render :text =>"true"
    else
      render :text =>"false"
    end
  end

  private
  def get_json
    load_page_data

    conditions = '1=1'
    condition_values = []
    if(params[:search_name] && params[:search_name] != '')
      conditions += " AND name like ? "
      condition_values << "%#{params[:search_name]}%"
    end

    if(params[:search_page_module_id] && params[:search_page_module_id] != '')
      conditions += " AND page_module_id = ? "
      condition_values << params[:search_page_module_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @pages = Page.paginate(:order =>"id DESC", :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = Page.count(:conditions => option_conditions)
    else
      @pages = Page.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = Page.count
    end
    return render_json(@pages,count)
  end
end
