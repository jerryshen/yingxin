class StudentsController < ApplicationController
  protect_from_forgery :except => [:prev, :next, :last]
  # GET /students
  # GET /students.xml
  def index
    @students = Student.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @students }
      format.json { render :text => get_json }
    end
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

  # POST /students
  # POST /students.xml
  def create
    @student = Student.new(params[:student])

    respond_to do |format|
      if @student.save
        flash[:notice] = 'Student was successfully created.'
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
        flash[:notice] = 'Student was successfully updated.'
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

  def class_dispatch

  end

  def dispatch
    major_id = params[:major_id]
    if major_id.blank?
      return render :text => "未选择专业"
    end
    begin
      success = Student.dispatch(major_id)
      if success
        redirect_to :action => 'index', :id => major_id
      else
        render :text => "批量分班失败"
      end
    rescue => error
      render :text => error.to_s
    end
  end

  private
  def get_json
    load_page_data
    if(params[:search_name] && params[:search_name].to_s!='')
      @students = Student.paginate(:order =>"id ASC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=> @pagesize,:page => params[:page] || 1)
      count = Student.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @students = Student.paginate(:order =>"id ASC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = Student.count
    end
    return render_json(@students,count)
  end
end
