class FeeStdsController < ApplicationController
  # GET /fee_stds
  # GET /fee_stds.xml
  def index
    @fee_stds = FeeStd.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fee_stds }
      format.json { render :text => get_json }
    end
  end

  # GET /fee_stds/1
  # GET /fee_stds/1.xml
  def show
    @fee_std = FeeStd.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fee_std }
    end
  end

  # GET /fee_stds/new
  # GET /fee_stds/new.xml
  def new
    @fee_std = FeeStd.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fee_std }
    end
  end

  # GET /fee_stds/1/edit
  def edit
    @fee_std = FeeStd.find(params[:id])
  end

  # POST /fee_stds
  # POST /fee_stds.xml
  def create
    @fee_std = FeeStd.new(params[:fee_std])

    respond_to do |format|
      if @fee_std.save
        format.html { redirect_to(@fee_std) }
        format.xml  { render :xml => @fee_std, :status => :created, :location => @fee_std }
        format.json { render :text => '{status: "success", message: "成功添加收费标准！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @fee_std.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@fee_std.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /fee_stds/1
  # PUT /fee_stds/1.xml
  def update
    @fee_std = FeeStd.find(params[:id])

    respond_to do |format|
      if @fee_std.update_attributes(params[:fee_std])
        format.html { redirect_to(@fee_std) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新收费标准！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @fee_std.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@fee_std.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /fee_stds/1
  # DELETE /fee_stds/1.xml
  def destroy
    @fee_std = FeeStd.find(params[:id])
    @fee_std.destroy

    respond_to do |format|
      format.html { redirect_to(fee_stds_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  private
  def get_json
    load_page_data
    if(params[:search_name] && params[:search_name].to_s!='')
      @fee_stds = FeeStd.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=> @pagesize,:page => params[:page] || 1)
      count = FeeStd.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @fee_stds = FeeStd.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = FeeStd.count
    end
    return render_json(@fee_stds,count)
  end
end
