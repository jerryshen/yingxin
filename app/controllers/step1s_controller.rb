class Step1sController < ApplicationController
  protect_from_forgery :except => [:update_theme]
  # GET /step1s
  # GET /step1s.xml
  def index
    @step1s = Proce.all
    @subject = Subject.find_by_index(1)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @step1s }
      format.json { render :text => get_json }
    end
  end

  # GET /step1s/1
  # GET /step1s/1.xml
  def show
    @step1 = Proce.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @step1 }
    end
  end

  # GET /step1s/1/edit
  def edit
    @step1 = Proce.find(params[:id])
  end

  # PUT /step1s/1
  # PUT /step1s/1.xml
  def update
    @step1 = Proce.find(params[:id])

    respond_to do |format|
      if @step1.update_attributes(params[:step1])
        format.html { redirect_to(@step1) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新入学资格复查！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @step1.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@step1.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /step1s/1
  # DELETE /step1s/1.xml
  def destroy
    @step1 = Proce.find(params[:id])
    @step1.destroy

    respond_to do |format|
      format.html { redirect_to(step1s_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def pass
    @step1 = Proce.find(params[:id])
    if !@step1.step1
      if @step1.update_attributes(:step1 => true, :step1_date => Time.now)
        Student.proc_end(@step1)
        render :text =>"true"
      else
        render :text => "false"
      end
    else
      if @step1.update_attributes(:step1 => false, :step1_date => nil)
        Student.proc_restart(@step1)
        render :text =>"true"
      else
        render :text => "false"
      end
    end
  end

  private

  def get_json
    load_page_data

    joins = "INNER JOIN students p ON proces.student_id=p.id"
    conditions = '1=1'
    condition_values = []
    if(!params[:department_id].blank?)
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

    if(!params[:search_name].blank?)
      students = Student.find(:all, :conditions => ["name like ?", "%#{params[:search_name]}%"])
      ids = []
      unless students.blank?
        students.each do |u|
          ids.push(u.id)
        end
      end
      idss = ids.join(",")
      conditions += " AND p.id in (#{idss})"
      condition_values << []
    end

    if(!params[:search_stu_number].blank?)
      conditions += " AND p.stu_number = ?"
      condition_values << params[:search_stu_number]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @step1s = Proce.paginate(:order =>"id ASC", :joins => joins,:conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count(:joins => joins, :conditions => option_conditions)
    else
      @step1s = Proce.paginate(:order =>"id ASC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count
    end
    return render_json(@step1s,count)
  end
end
