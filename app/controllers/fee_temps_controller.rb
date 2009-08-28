class FeeTempsController < ApplicationController
  protect_from_forgery :except => [:ensure_fee]
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

  def ensure_fee
    record = FeeTemp.find(params[:id])
    if record
      #do something
      render :json => {:status => "success",:msg => "操作成功"}
      #or
      #render :json => {:status => "fail",:msg => "操作失败"}
    end
  end

    private
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
