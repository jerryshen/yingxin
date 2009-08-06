class Step3sController < ApplicationController
  # GET /step3s
  # GET /step3s.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @step3s }
      format.json { render :text => get_json }
    end
  end

  # GET /step3s/1
  # GET /step3s/1.xml
  def show
    @step3 = Proce.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @step3 }
    end
  end

  # GET /step3s/1/edit
  def edit
    @step3 = Proce.find(params[:id])
  end

  # PUT /step3s/1
  # PUT /step3s/1.xml
  def update
    @step3 = Proce.find(params[:id])

    respond_to do |format|
      if @step3.update_attributes(params[:step3])
        format.html { redirect_to(@step3) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新军训费用缴纳情况！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @step3.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@step3.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /step3s/1
  # DELETE /step3s/1.xml
  def destroy
    @step3 = Proce.find(params[:id])
    @step3.destroy

    respond_to do |format|
      format.html { redirect_to(step3s_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def pass
    @step3 = Proce.find(params[:id])
    if @step3.step1 == true
    if !@step3.step3
      if @step3.update_attributes(:step3 => true, :step3_date => Time.now)
#        Student.proc_end(@step3)
        render :text =>"true"
      else
        render :text => "false"
      end
    else
      if @step3.update_attributes(:step3 => false, :step3_date => nil)
#        Student.proc_restart(@step3)
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
      @step3s = Proce.paginate(:order =>"id ASC", :joins => joins,:conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count(:joins => joins, :conditions => option_conditions)
    else
      @step3s = Proce.paginate(:order =>"id ASC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count
    end
    return render_json(@step3s,count)
  end
end
