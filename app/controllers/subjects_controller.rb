class SubjectsController < ApplicationController
  # GET /subjects
  # GET /subjects.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subjects }
      format.json { render :text => get_json }
    end
  end

  # GET /subjects/1
  # GET /subjects/1.xml
  def show
    @subject = Subject.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subject }
    end
  end

  # GET /subjects/new
  # GET /subjects/new.xml
  def new
    @subject = Subject.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subject }
    end
  end

  # GET /subjects/1/edit
  def edit
    @subject = Subject.find(params[:id])
  end

  # POST /subjects
  # POST /subjects.xml
  def create
    @subject = Subject.new(params[:subject])

    respond_to do |format|
      if @subject.save
        format.html { redirect_to(@subject) }
        format.xml  { render :xml => @subject, :status => :created, :location => @subject }
        format.json { render :text => '{status: "success", message: "成功添加报到项！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subject.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@tip.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /subjects/1
  # PUT /subjects/1.xml
  def update
    @subject = Subject.find(params[:id])

    respond_to do |format|
      if @subject.update_attributes(params[:subject])
        format.html { redirect_to(@subject) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新报到项！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subject.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@tip.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.xml
  def destroy
    @subject = Subject.find(params[:id])
    @subject.destroy

    respond_to do |format|
      format.html { redirect_to(subjects_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  private
  def get_json
    load_page_data
    if(params[:search_name] && params[:search_name].to_s!='')
      @subjects = Subject.paginate(:order =>"id ASC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=> @pagesize,:page => params[:page] || 1)
      count = Subject.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @subjects = Subject.paginate(:order =>"id ASC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = Subject.count
    end
    return render_json(@subjects,count)
  end
end
