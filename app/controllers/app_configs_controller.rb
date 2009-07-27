class AppConfigsController < ApplicationController

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @app_configs }
      format.json { render :text => get_json }
    end
  end

  def show
    @app_config = AppConfig.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @app_config }
    end
  end

  def new
    @app_config = AppConfig.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @app_config }
    end
  end


  def edit
    @app_config = AppConfig.find(params[:id])
  end


  def create
    @app_config = AppConfig.new(params[:app_config])

    respond_to do |format|
      if @app_config.save
        format.html { redirect_to(@app_config) }
        format.xml  { render :xml => @app_config, :status => :created, :location => @app_config }
        format.json { render :text => '{status: "success", message: "成功添加系统配置"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @app_config.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@app_config.errors.full_messages.to_json}}"}
      end
    end
  end

  def update
    @app_config = AppConfig.find(params[:id])

    respond_to do |format|
      if @app_config.update_attributes(params[:app_config])
        format.html { redirect_to(@app_config) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功xiugai系统配置"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @app_config.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@app_config.errors.full_messages.to_json}}"}
      end
    end
  end

  def destroy
    @app_config = AppConfig.find(params[:id])
    @app_config.destroy

    respond_to do |format|
      format.html { redirect_to(app_configs_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  private
  def get_json
    load_page_data
    if(params[:search_name] && params[:search_name].to_s!='')
      @app_configs = AppConfig.paginate(:order =>"id DESC", :conditions => ["key like ?","%#{params[:search_name]}%"],:per_page=>@pagesize,:page => params[:page] || 1)
      count = AppConfig.count(:conditions =>["key like ?","%#{params[:search_name]}%"])
    else
      @app_configs = AppConfig.paginate(:order =>"id DESC",:per_page=>@pagesize,:page => params[:page] || 1)
      count = AppConfig.count
    end
    return render_json(@app_configs,count)
  end
end
