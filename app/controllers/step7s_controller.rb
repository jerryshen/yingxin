class Step7sController < ApplicationController
  # GET /step7s
  # GET /step7s.xml
  def index
    @step7s = Proce.all
    @subject = Subject.find_by_index(7)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @step7s }
      format.json { render :text => get_json }
    end
  end

  # GET /step7s/1
  # GET /step7s/1.xml
  def show
    @step7 = Proce.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @step7 }
    end
  end

  # GET /step7s/1/edit
  def edit
    @step7 = Proce.find(params[:id])
  end

  # PUT /step7s/1
  # PUT /step7s/1.xml
  def update
    @step7 = Proce.find(params[:id])

    respond_to do |format|
      if @step7.update_attributes(params[:step7])
        format.html { redirect_to(@step7) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新公寓入住情况！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @step7.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@step7.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /step7s/1
  # DELETE /step7s/1.xml
  def destroy
    @step7 = Proce.find(params[:id])
    @step7.destroy

    respond_to do |format|
      format.html { redirect_to(step7s_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def pass
    @step7 = Proce.find(params[:id])
    if !@step7.step7
      if @step7.update_attributes(:step7 => true, :step7_date => Time.now)
        Student.proc_end(@step7)
        render :text =>"true"
      else
        render :text => "false"
      end
    else
      if @step7.update_attributes(:step7 => false, :step7_date => nil)
        Student.proc_restart(@step7)
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
      @step7s = Proce.paginate(:order =>"id DESC", :joins => joins,:conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count(:joins => joins, :conditions => option_conditions)
    else
      @step7s = Proce.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count
    end
    return render_json(@step7s,count)
  end
end
