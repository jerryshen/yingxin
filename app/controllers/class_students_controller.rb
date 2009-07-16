class ClassStudentsController < ApplicationController
  # GET /class_students
  # GET /class_students.xml
  def index
    @class_students = ClassStudent.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @class_students }
      format.json { render :text => get_json }
    end
  end

  # GET /class_students/1
  # GET /class_students/1.xml
  def show
    @class_student = ClassStudent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @class_student }
    end
  end

  # GET /class_students/new
  # GET /class_students/new.xml
  def new
    @class_student = ClassStudent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @class_student }
    end
  end

  # GET /class_students/1/edit
  def edit
    @class_student = ClassStudent.find(params[:id])
  end

  # POST /class_students
  # POST /class_students.xml
  def create
    @class_student = ClassStudent.new(params[:class_student])

    respond_to do |format|
      if @class_student.save
        format.html { redirect_to(@class_student) }
        format.xml  { render :xml => @class_student, :status => :created, :location => @class_student }
        format.json { render :text => '{status: "success", message: "个人调整成功！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @class_student.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@class_student.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /class_students/1
  # PUT /class_students/1.xml
  def update
    @class_student = ClassStudent.find(params[:id])

    respond_to do |format|
      if @class_student.update_attributes(params[:class_student])
        format.html { redirect_to(@class_student) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "个人调整成功！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @class_student.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@class_student.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /class_students/1
  # DELETE /class_students/1.xml
  def destroy
    @class_student = ClassStudent.find(params[:id])
    @class_student.destroy

    respond_to do |format|
      format.html { redirect_to(class_students_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  private

  def get_json
    load_page_data

    joins = "INNER JOIN students p ON class_students.student_id=p.id"
    conditions = '1=1'
    condition_values = []
    if(!params[:dpartment_id].blank?)
      conditions += " AND p.department_id = ? "
      condition_values << params[:department_id]
    end

    if(!params[:major_id].blank?)
      conditions += " AND p.major_id = ? "
      condition_values << params[:major_id]
    end

    if(!params[:class_id].blank?)
      conditions += " AND p.info_class_id = ? "
      condition_values << params[:class_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @class_students = ClassStudent.paginate(:order =>"id DESC", :joins => joins,:conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = ClassStudent.count(:joins => joins, :conditions => option_conditions)
    else
      @class_students = ClassStudent.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = ClassStudent.count
    end
    return render_json(@class_students,count)
  end
end
