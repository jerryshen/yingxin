class TempsController < ApplicationController
  # GET /temps
  # GET /temps.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @temps }
      format.json { render :text => get_json }
    end
  end

  # GET /temps/1
  # GET /temps/1.xml
  def show
    @temp = Temp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @temp }
    end
  end


  # GET /temps/1/edit
  def edit
    @temp = Temp.find(params[:id])
  end

  # PUT /temps/1
  # PUT /temps/1.xml
  def update
    @temp = Temp.find(params[:id])

    respond_to do |format|
      if @temp.update_attributes(params[:temp])
        format.html { redirect_to(@temp) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新记录！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @temp.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@temp.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /temps/1
  # DELETE /temps/1.xml
  def destroy
    @temp = Temp.find(params[:id])
    @temp.destroy

    respond_to do |format|
      format.html { redirect_to(temps_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  private

    def get_json
    load_page_data

    conditions = '1=1'
    condition_values = []
    if(!params[:dpartment_id].blank?)
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
      @temps = Temp.paginate(:order =>"id DESC", :joins => joins,:conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = Temp.count(:joins => joins, :conditions => option_conditions)
    else
      @temps = Temp.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = Temp.count
    end
    return render_json(@temps,count)
  end
end
