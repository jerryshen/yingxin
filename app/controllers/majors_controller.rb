class MajorsController < ApplicationController
  protect_from_forgery :except => [:classes_to_json]
  # GET /majors
  # GET /majors.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @majors }
      format.json { render :text => get_json }
    end
  end

  # GET /majors/1
  # GET /majors/1.xml
  def show
    @major = Major.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @major }
    end
  end

  # GET /majors/new
  # GET /majors/new.xml
  def new
    @major = Major.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @major }
    end
  end

  # GET /majors/1/edit
  def edit
    @major = Major.find(params[:id])
  end

  # POST /majors
  # POST /majors.xml
  def create
    @major = Major.new(params[:major])

    respond_to do |format|
      if @major.save
        format.html { redirect_to(@major) }
        format.xml  { render :xml => @major, :status => :created, :location => @major }
        format.json { render :text => '{status: "success", message: "成功添加专业！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @major.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@major.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /majors/1
  # PUT /majors/1.xml
  def update
    @major = Major.find(params[:id])

    respond_to do |format|
      if @major.update_attributes(params[:major])
        format.html { redirect_to(@major) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新专业！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @major.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@major.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /majors/1
  # DELETE /majors/1.xml
  def destroy
    @major = Major.find(params[:id])
    @major.destroy

    respond_to do |format|
      format.html { redirect_to(majors_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def classes_to_json
    if request.post?
      major = Major.find(params[:id])
      if(major)
        render :text => major.classes_to_json
      end
    end
  end

  private
  def get_json
    load_page_data
    if(params[:search_name] && params[:search_name].to_s!='')
      @majors = Major.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=> @pagesize,:page => params[:page] || 1)
      count = Major.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @majors = Major.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = Major.count
    end
    return render_json(@majors,count)
  end
end
