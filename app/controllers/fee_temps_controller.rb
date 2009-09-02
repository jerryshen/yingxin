class FeeTempsController < ApplicationController
  protect_from_forgery :except => [:ensure_one, :ensure_all]
  # GET /fee_temps
  # GET /fee_temps.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fee_temps }
      format.json { render :text => get_json }
    end
  end

  # GET /fee_temps/1
  # GET /fee_temps/1.xml
  def show
    @fee_temp = FeeTemp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fee_temp }
    end
  end

  # GET /fee_temps/1/edit
  def edit
    @fee_temp = FeeTemp.find(params[:id])
  end

  # PUT /fee_temps/1
  # PUT /fee_temps/1.xml
  def update
    @fee_temp = FeeTemp.find(params[:id])

    respond_to do |format|
      if @fee_temp.update_attributes(params[:fee_temp])
        format.html { redirect_to(@fee_temp) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @fee_temp.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@building.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /fee_temps/1
  # DELETE /fee_temps/1.xml
  def destroy
    @fee_temp = FeeTemp.find(params[:id])
    @fee_temp.destroy

    respond_to do |format|
      format.html { redirect_to(fee_temps_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def ensure_all
    begin
      count = FeeTemp.count
      n = 0
      FeeTemp.find_each do |record|
        n += 1 if ensure_fee(record)
      end
      render :json => {:status => "success", :msg=>"成功确认#{n}条收款记录，忽略#{count-n}条记录!"}
    rescue
      render :json => {:status => "fail",:msg => "操作失败"}
    end
  end

  def ensure_one
    record = FeeTemp.find(params[:id])
    begin
      if record and ensure_fee(record) 
        return render :json => {:status => "success",:msg => "操作成功"}
      end
    rescue
    end
    render :json => {:status => "fail",:msg => "操作失败"}
  end

  private
  def ensure_fee(record)
    student = Student.first(:conditions => {:can_number => record.f1})
    unless student.nil?
      if record.f4 > 0 or record.f2 == record.f3
        proc = student.proce
        if proc
          proc.update_attributes(:step2 => true)
        end
      end
      record.destroy
      return true
    end
    return false
  end

  def get_json
    load_page_data
    if(!params[:search_name].blank?)
      @fee_temps = FeeTemp.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=> @pagesize,:page => params[:page] || 1)
      count = FeeTemp.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @fee_temps = FeeTemp.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = FeeTemp.count
    end
    return render_json(@fee_temps,count)
  end
end
