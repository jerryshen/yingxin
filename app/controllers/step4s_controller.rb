class Step4sController < ApplicationController
  # GET /step4s
  # GET /step4s.xml
  def index
    @step4s = Step4.all
    @subject = Subject.find_by_index(4)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @step4s }
      format.json { render :text => get_json }
    end
  end

  # GET /step4s/1
  # GET /step4s/1.xml
  def show
    @step4 = Step4.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @step4 }
    end
  end

  # GET /step4s/1/edit
  def edit
    @step4 = Step4.find(params[:id])
  end

  # PUT /step4s/1
  # PUT /step4s/1.xml
  def update
    @step4 = Step4.find(params[:id])

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
    @step4 = Step4.find(params[:id])
    @step4.destroy

    respond_to do |format|
      format.html { redirect_to(step4s_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def pass
    @step4 = Step4.find(params[:id])
    if @step4.update_attributes(:pass => !@step4.pass, :date => Time.now)
      render :text =>"true"
    else
      render :text =>"false"
    end
  end

  private

  def get_json
    load_page_data

    joins = "INNER JOIN students p ON step4s.student_id=p.id"
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
      @step4s = Step4.paginate(:order =>"id DESC", :joins => joins,:conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = Step4.count(:joins => joins, :conditions => option_conditions)
    else
      @step4s = Step4.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = Step4.count
    end
    return render_json(@step4s,count)
  end
end
