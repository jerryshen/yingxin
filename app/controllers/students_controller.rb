class StudentsController < ApplicationController
  protect_from_forgery :except => [:prev, :next, :last, :data_migrate]
  # GET /students
  # GET /students.xml
  def index
    @search_major = ''
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @students }
      format.json { render :text => get_json }
    end
  end

  def print
    if params[:major_id].blank?
      @students = Student.all
      @caption = "所有新生"
    else
      major = Major.find(params[:major_id].to_i)
      if major
        @students = major.students
        @caption = "#{major.name}专业新生"
      end
    end
    render :layout => false
  end

  # GET /students/1
  # GET /students/1.xml
  def show
    @student = Student.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
  end

  # GET /students/new
  # GET /students/new.xml
  def new
    @student = Student.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student }
    end
  end

  # GET /students/1/edit
  def edit
    @student = Student.find(params[:id])
  end

  def prev
    @student = Student.find(:last, :conditions => ["id < ?", params[:id]], :order => "id ASC")
    if @student
      render :action => "edit"
    else
      render :text => "nodata"
    end
  end

  def next
    @student =  Student.find(:first, :conditions => ["id > ?", params[:id]], :order => "id ASC")
    if @student
      render :action => "edit"
    else
      render :text => "nodata"
    end
  end

  def last
    @student =  Student.last
    if @student
      render :action => "edit"
    else
      render :text => "nodata"
    end
  end
  
  def dispatch
    render :layout => false
  end
  
  def do_dispatch
    major = Major.find(params[:major_id])
    if major
      begin
        if Student.dispatch(major.id)
          @search_major = major.id
          render :index
        end
      rescue => error
        flash[:error] = error.to_s
      end
    else
      render :dispatch
    end
  end

  # POST /students
  # POST /students.xml
  def create
    @student = Student.new(params[:student])

    respond_to do |format|
      if @student.save
        format.html { redirect_to(@student) }
        format.xml  { render :xml => @student, :status => :created, :location => @student }
        format.json { render :text => '{status: "success", message: "成功添加新生！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@student.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /students/1
  # PUT /students/1.xml
  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.html { redirect_to(@student) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新新生！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@student.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.xml
  def destroy
    @student = Student.find(params[:id])
    @student.destroy

    respond_to do |format|
      format.html { redirect_to(students_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def upload_thumb
    @student = Student.find(params[:id])
    @thumb_url = ''
    if request.post?
      if params[:thumb]
        @thumb_url = @student.upload_thumb(params[:thumb])
      end
    end
  end

  def data_migrate
    begin
      count = Student.count - Proce.count
      Student.import_to_proce
      render :json => {:status => "success", :msg=>"成功确认#{count}条记录!"}
    rescue
      render :json => {:status => "fail",:msg => "操作失败"}
    end
  end

  private
  def get_json
    load_page_data
    sql = []
    values = []
    if(params[:search_name] && params[:search_name].to_s!='')
      sql.push("name like ?")
      values.push("%#{params[:search_name]}%")
    end
    if(!params[:search_can_number].blank?)
      sql.push("can_number =?")
      values.push(params[:search_can_number])
    end
    if(params[:search_major] && params[:search_major].to_s!='')
      sql.push("major_id = ?")
      values.push(params[:search_major])
    end
    if sql.length > 0
      conditions = []
      conditions << sql.join(" AND ")
      conditions += values
      @students = Student.paginate(:order =>"id ASC", :conditions => conditions,:per_page=> @pagesize,:page => params[:page] || 1)
      count = Student.count(:conditions => conditions)
    else
      @students = Student.paginate(:order =>"id ASC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = Student.count
    end
    return render_json(@students,count)
  end
end
