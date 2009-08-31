class Step8sController < ApplicationController
  # GET /step8s
  # GET /step8s.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @step8s }
      format.json { render :text => get_json }
    end
  end

  # GET /step8s/1
  # GET /step8s/1.xml
  def show
    @step8 = Step8.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @step8 }
    end
  end

  # GET /step8s/1/edit
  def edit
    @step8 = Step8.find(params[:id])
  end

  # PUT /step8s/1
  # PUT /step8s/1.xml
  def update
    @step8 = Step8.find(params[:id])

    respond_to do |format|
      if @step8.update_attributes(params[:step8])
        format.html { redirect_to(@step8) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新注册情况！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @step8.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@step8.errors.full_messages.to_json}}"}
      end
    end
  end

  def pass
    @step8 = Proce.find(params[:id])
    if @step8.step1 == true
      if !@step8.step8
        if @step8.update_attributes(:step8 => true, :step8_date => Time.now)
          #        Student.proc_end(@step8)
          render :text =>"true"
        else
          render :text => "false"
        end
      else
        if @step8.update_attributes(:step8 => false, :step8_date => nil)
          #        Student.proc_restart(@step8)
          render :text =>"true"
        else
          render :text => "false"
        end
      end
    else
      render :text => "false"
    end
  end

  private

  def get_json
    load_page_data

    joins = "INNER JOIN students p ON proces.student_id=p.id"
    conditions = '1=1'
    condition_values = []
    if(!params[:department_id].blank?)
      majors = Department.find(params[:department_id]).majors
      ids = []
      unless majors.blank?
        majors.each do |m|
          ids.push(m.id)
        end
      end
      idss = ids.join(",")
      conditions += " AND p.major_id in (#{idss}) "
      condition_values << []
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

    if(!params[:search_can_number].blank?)
      conditions += " AND p.can_number = ?"
      condition_values << params[:search_can_number]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @step8s = Proce.paginate(:order =>"id ASC", :joins => joins,:conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count(:joins => joins, :conditions => option_conditions)
    else
      @step8s = Proce.paginate(:order =>"id ASC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count
    end
    return render_json(@step8s,count)
  end
end
