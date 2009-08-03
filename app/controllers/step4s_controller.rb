class Step4sController < ApplicationController
  # GET /step4s
  # GET /step4s.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @step4s }
      format.json { render :text => get_json }
    end
  end

  # GET /step4s/1
  # GET /step4s/1.xml
  def show
    @step4 = Proce.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @step4 }
    end
  end

  # GET /step4s/1/edit
  def edit
    @step4 = Proce.find(params[:id])
  end

  # PUT /step4s/1
  # PUT /step4s/1.xml
  def update
    @step4 = Proce.find(params[:id])

    respond_to do |format|
      if @step4.update_attributes(params[:step4])
        format.html { redirect_to(@step4) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新保险办理情况！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @step4.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@step4.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /step4s/1
  # DELETE /step4s/1.xml
  def destroy
    @step4 = Proce.find(params[:id])
    @step4.destroy

    respond_to do |format|
      format.html { redirect_to(step4s_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def pass
    @step4 = Proce.find(params[:id])
    if !@step4.step4
      if @step4.update_attributes(:step4 => true, :step4_date => Time.now)
#        Student.proc_end(@step4)
        render :text =>"true"
      else
        render :text => "false"
      end
    else
      if @step4.update_attributes(:step4 => false, :step4_date => nil)
#        Student.proc_restart(@step4)
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
      @step4s = Proce.paginate(:order =>"id ASC", :joins => joins,:conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count(:joins => joins, :conditions => option_conditions)
    else
      @step4s = Proce.paginate(:order =>"id ASC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count
    end
    return render_json(@step4s,count)
  end
end
