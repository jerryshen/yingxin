class Step5sController < ApplicationController
  # GET /step5s
  # GET /step5s.xml
  def index
    @step5s = Proce.all
    @subject = Subject.find_by_index(5)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @step5s }
      format.json { render :text => get_json }
    end
  end

  # GET /step5s/1
  # GET /step5s/1.xml
  def show
    @step5 = Proce.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @step5 }
    end
  end

  # GET /step5s/1/edit
  def edit
    @step5 = Proce.find(params[:id])
  end

  # PUT /step5s/1
  # PUT /step5s/1.xml
  def update
    @step5 = Proce.find(params[:id])

    respond_to do |format|
      if @step5.update_attributes(params[:step5])
        format.html { redirect_to(@step5) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新入学报到注册情况！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @step5.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@step5.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /step5s/1
  # DELETE /step5s/1.xml
  def destroy
    @step5 = Proce.find(params[:id])
    @step5.destroy

    respond_to do |format|
      format.html { redirect_to(step5s_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def pass
    @step5 = Proce.find(params[:id])
    if !@step5.step5
      if @step5.update_attributes(:step5 => true, :step5_date => Time.now)
        Student.proc_end(@step5)
        render :text =>"true"
      else
        render :text => "false"
      end
    else
      if @step5.update_attributes(:step5 => false, :step5_date => nil)
        Student.proc_restart(@step5)
        render :text =>"true"
      else
        render :text => "false"
      end
    end
  end

  private

  def get_json
    load_page_data

    department_id = @current_user.department.id

    joins = "INNER JOIN students p ON proces.student_id=p.id"
    conditions = "1=1 AND p.department_id = #{department_id}"
    condition_values = []

    if(!params[:major_id].blank?)
      conditions += " AND p.major_id = ? "
      condition_values << params[:major_id]
    end

    if(!params[:class_id].blank?)
      conditions += " AND p.info_class_id = ? "
      condition_values << params[:class_id]
    end

    if(conditions != '1=1 AND p.department_id = #{department_id}')
      option_conditions = [conditions,condition_values].flatten!
      @step5s = Proce.paginate(:order =>"id DESC", :joins => joins,:conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count(:joins => joins, :conditions => option_conditions)
    else
      @step5s = Proce.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count(:joins => joins, :conditions => conditions)
    end
    return render_json(@step5s,count)
  end
end
