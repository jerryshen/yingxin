class Step6sController < ApplicationController
  # GET /step6s
  # GET /step6s.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @step6s }
      format.json { render :text => get_json }
    end
  end

  # GET /step6s/1
  # GET /step6s/1.xml
  def show
    @step6 = Proce.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @step6 }
    end
  end

  # GET /step6s/1/edit
  def edit
    @step6 = Proce.find(params[:id])
  end

  # PUT /step6s/1
  # PUT /step6s/1.xml
  def update
    @step6 = Proce.find(params[:id])

    respond_to do |format|
      if @step6.update_attributes(params[:step6])
        format.html { redirect_to(@step6) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新日用品购买情况！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @step6.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@step6.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /step6s/1
  # DELETE /step6s/1.xml
  def destroy
    @step6 = Proce.find(params[:id])
    @step6.destroy

    respond_to do |format|
      format.html { redirect_to(step6s_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def pass
    @step6 = Proce.find(params[:id])
    if @step6.step1 == true
      if !@step6.step6
        if @step6.update_attributes(:step6 => true, :step6_date => Time.now)
          #        Student.proc_end(@step6)
          render :text =>"true"
        else
          render :text => "false"
        end
      else
        if @step6.update_attributes(:step6 => false, :step6_date => nil)
          #        Student.proc_restart(@step6)
          render :text =>"true"
        else
          render :text => "false"
        end
      end
    else
      render :text => "false"
    end
  end

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
      @step6s = Proce.paginate(:order =>"id ASC", :joins => joins,:conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count(:joins => joins, :conditions => option_conditions)
    else
      @step6s = Proce.paginate(:order =>"id ASC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count
    end
    return render_json(@step6s,count)
  end
end
