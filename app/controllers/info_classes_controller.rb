class InfoClassesController < ApplicationController
   protect_from_forgery :except => [:students_to_json]
  # GET /info_classes
  # GET /info_classes.xml
  def index
    @info_classes = InfoClass.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @info_classes }
      format.json { render :text => get_json }
    end
  end

  # GET /info_classes/1
  # GET /info_classes/1.xml
  def show
    @info_class = InfoClass.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @info_class }
    end
  end

  # GET /info_classes/new
  # GET /info_classes/new.xml
  def new
    @info_class = InfoClass.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @info_class }
    end
  end

  # GET /info_classes/1/edit
  def edit
    @info_class = InfoClass.find(params[:id])
  end

  # POST /info_classes
  # POST /info_classes.xml
  def create
    @info_class = InfoClass.new(params[:info_class])

    respond_to do |format|
      if @info_class.save
        format.html { redirect_to(@info_class) }
        format.xml  { render :xml => @info_class, :status => :created, :location => @info_class }
        format.json { render :text => '{status: "success", message: "成功添加班级！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @info_class.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@info_class.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /info_classes/1
  # PUT /info_classes/1.xml
  def update
    @info_class = InfoClass.find(params[:id])

    respond_to do |format|
      if @info_class.update_attributes(params[:info_class])
        format.html { redirect_to(@info_class) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新班级！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @info_class.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@info_class.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /info_classes/1
  # DELETE /info_classes/1.xml
  def destroy
    @info_class = InfoClass.find(params[:id])
    @info_class.destroy

    respond_to do |format|
      format.html { redirect_to(info_classes_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def selector
   # render :layout => false
  end

  def students_to_json
    if request.post?
      info_class = InfoClass.find(params[:id])
      if(info_class)
        render :text => info_class.students_to_json
      end
    end
  end

  private
  def get_json
    load_page_data
    if(params[:search_name] && params[:search_name].to_s!='')
      @info_classes = InfoClass.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=> @pagesize,:page => params[:page] || 1)
      count = InfoClass.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @info_classes = InfoClass.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = InfoClass.count
    end
    return render_json(@info_classes,count)
  end
end
