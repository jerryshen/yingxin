class TipsController < ApplicationController
  # GET /tips
  # GET /tips.xml
  def index
    @tips = Tip.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tips }
      format.json { render :text => get_json }
    end
  end

  # GET /tips/1
  # GET /tips/1.xml
  def show
    @tip = Tip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tip }
    end
  end

  # GET /tips/new
  # GET /tips/new.xml
  def new
    @tip = Tip.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tip }
    end
  end

  # GET /tips/1/edit
  def edit
    @tip = Tip.find(params[:id])
  end

  # POST /tips
  # POST /tips.xml
  def create
    @tip = Tip.new(params[:tip])
    @tip.user_id = @current_user.id

    respond_to do |format|
      if @tip.save
        format.html { redirect_to(@tip) }
        format.xml  { render :xml => @tip, :status => :created, :location => @tip }
        format.json { render :text => '{status: "success", message: "成功添加通知！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tip.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@tip.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /tips/1
  # PUT /tips/1.xml
  def update
    @tip = Tip.find(params[:id])
    @tip.user_id = @current_user.id

    respond_to do |format|
      if @tip.update_attributes(params[:tip])
        format.html { redirect_to(@tip) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新通知！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tip.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@tip.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /tips/1
  # DELETE /tips/1.xml
  def destroy
    @tip = Tip.find(params[:id])
    @tip.destroy

    respond_to do |format|
      format.html { redirect_to(tips_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def top
    @tip = Tip.find(params[:id])
    if @tip.update_attributes(:top => !@tip.top)
      render :text =>"true"
    else
      render :text =>"false"
    end
  end

  def hide
    @tip = Tip.find(params[:id])
    if @tip.update_attributes(:hidden => !@tip.hidden)
      render :text =>"true"
    else
      render :text =>"false"
    end
  end

  private
  def get_json
    load_page_data
    if(params[:search_name] && params[:search_name].to_s!='')
      @tips = Tip.paginate(:order =>"id DESC", :conditions => ["title like ?","%#{params[:search_name]}%"],:per_page=> @pagesize,:page => params[:page] || 1)
      count = Tip.count(:conditions =>["title like ?","%#{params[:search_name]}%"])
    else
      @tips = Tip.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = Tip.count
    end
    return render_json(@tips,count)
  end
end
