class RoomStudentsController < ApplicationController
  # GET /room_students
  # GET /room_students.xml
  def index
    @room_students = RoomStudent.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @room_students }
      format.json { render :text => get_json }
    end
  end

  # GET /room_students/1
  # GET /room_students/1.xml
  def show
    @room_student = RoomStudent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @room_student }
    end
  end

  # GET /room_students/new
  # GET /room_students/new.xml
  def new
    @room_student = RoomStudent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @room_student }
    end
  end

  # GET /room_students/1/edit
  def edit
    @room_student = RoomStudent.find(params[:id])
  end

  # POST /room_students
  # POST /room_students.xml
  def create
    @room_student = RoomStudent.new(params[:room_student])

    respond_to do |format|
      if @room_student.save
        flash[:notice] = 'RoomStudent was successfully created.'
        format.html { redirect_to(@room_student) }
        format.xml  { render :xml => @room_student, :status => :created, :location => @room_student }
        format.json { render :text => '{status: "success", message: "成功分配到宿舍！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @room_student.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@room_student.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /room_students/1
  # PUT /room_students/1.xml
  def update
    @room_student = RoomStudent.find(params[:id])

    respond_to do |format|
      if @room_student.update_attributes(params[:room_student])
        flash[:notice] = 'RoomStudent was successfully updated.'
        format.html { redirect_to(@room_student) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改分配！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @room_student.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@room_student.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /room_students/1
  # DELETE /room_students/1.xml
  def destroy
    @room_student = RoomStudent.find(params[:id])
    @room_student.destroy

    respond_to do |format|
      format.html { redirect_to(room_students_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  private
  def get_json
    load_page_data
    if(params[:search_name] && params[:search_name].to_s!='')
      @room_students = RoomStudent.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=> @pagesize,:page => params[:page] || 1)
      count = RoomStudent.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @room_students = RoomStudent.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = RoomStudent.count
    end
    return render_json(@room_students,count)
  end
end
