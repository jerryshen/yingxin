class Step2sController < ApplicationController
  # GET /step2s
  # GET /step2s.xml
  def index
    @step2s = Proce.all
    @subject = Subject.find_by_index(2)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @step2s }
      format.json { render :text => get_json }
    end
  end

  # GET /step2s/1
  # GET /step2s/1.xml
  def show
    @step2 = Proce.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @step2 }
    end
  end

  # GET /step2s/1/edit
  def edit
    @step2 = Proce.find(params[:id])
  end

  # PUT /step2s/1
  # PUT /step2s/1.xml
  def update
    @step2 = Proce.find(params[:id])

    respond_to do |format|
      if @step2.update_attributes(params[:step2])
        format.html { redirect_to(@step2) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新缴费情况！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @step2.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@step2.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /step2s/1
  # DELETE /step2s/1.xml
  def destroy
    @step2 = Proce.find(params[:id])
    @step2.destroy

    respond_to do |format|
      format.html { redirect_to(step2s_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def pass
    @step2 = Proce.find(params[:id])
    if !@step2.step2
      if @step2.update_attributes(:step2 => true, :step2_date => Time.now)
        Student.proc_end(@step2)
        render :text =>"true"
      else
        render :text => "false"
      end
    else
      if @step2.update_attributes(:step2 => false, :step2_date => nil)
        Student.proc_restart(@step2)
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

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @step2s = Proce.paginate(:order =>"id DESC", :joins => joins,:conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count(:joins => joins, :conditions => option_conditions)
    else
      @step2s = Proce.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count
    end
    return render_json(@step2s,count)
  end
end
