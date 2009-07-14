class Step3sController < ApplicationController
  # GET /step3s
  # GET /step3s.xml
  def index
    @step3s = Step3.all
    @subject = Subject.find_by_index(3)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @step3s }
      format.json { render :text => get_json }
    end
  end

  # GET /step3s/1
  # GET /step3s/1.xml
  def show
    @step3 = Step3.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @step3 }
    end
  end

  # GET /step3s/1/edit
  def edit
    @step3 = Step3.find(params[:id])
  end

  # PUT /step3s/1
  # PUT /step3s/1.xml
  def update
    @step3 = Step3.find(params[:id])

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
    @step3 = Step3.find(params[:id])
    @step3.destroy

    respond_to do |format|
      format.html { redirect_to(step3s_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def pass
    @step3 = Step3.find(params[:id])
    if @step3.update_attributes(:pass => !@step3.pass, :date => Time.now)
      render :text =>"true"
    else
      render :text =>"false"
    end
  end

  private

  def get_json
    load_page_data

    joins = "INNER JOIN students p ON step3s.student_id=p.id"
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
      conditions += " AND p.class_id = ? "
      condition_values << params[:class_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @step3s = Step3.paginate(:order =>"id DESC", :joins => joins,:conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = Step3.count(:joins => joins, :conditions => option_conditions)
    else
      @step3s = Step3.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = Step3.count
    end
    return render_json(@step3s,count)
  end
end
