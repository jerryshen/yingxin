class BedsController < ApplicationController
  # GET /beds
  # GET /beds.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @beds }
      format.json { render :text => get_json }
    end
  end

  # GET /beds/1
  # GET /beds/1.xml
  def show
    @bed = Bed.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bed }
    end
  end

  # GET /beds/new
  # GET /beds/new.xml
  def new
    @bed = Bed.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bed }
    end
  end

  # GET /beds/1/edit
  def edit
    @bed = Bed.find(params[:id])
  end

  # POST /beds
  # POST /beds.xml
  def create
    @bed = Bed.new(params[:bed])

    respond_to do |format|
      if @bed.save
        format.html { redirect_to(@bed) }
        format.xml  { render :xml => @bed, :status => :created, :location => @bed }
        format.json { render :text => '{status: "success", message: "成功分配床位！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bed.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@bed.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /beds/1
  # PUT /beds/1.xml
  def update
    @bed = Bed.find(params[:id])

    respond_to do |format|
      if @bed.update_attributes(params[:bed])
        format.html { redirect_to(@bed) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功分配床位！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bed.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@bed.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /beds/1
  # DELETE /beds/1.xml
  def destroy
    @bed = Bed.find(params[:id])
    @bed.destroy

    respond_to do |format|
      format.html { redirect_to(beds_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  private

  def get_json
    load_page_data
    if(!params[:search_name].blank?)
      @beds = Bed.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=> @pagesize,:page => params[:page] || 1)
      count = Bed.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @beds = Bed.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = Bed.count
    end
    return render_json(@beds,count)
  end
end
