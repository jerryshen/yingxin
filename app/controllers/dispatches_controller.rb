class DispatchesController < ApplicationController
  # GET /dispatches
  # GET /dispatches.xml
  def index
    load_page_data
    major_id = params[:id]

    students = Student.find(:all, :conditions => ["major_id =?",major_id ])

    @dispatches = students.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
    count = students.length

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dispatches }
      format.json { render :text => render_json(@dispatches,count) }
    end
  end

  def class_dispatch
    
  end

  def dispatch
    major_id = params[:major_id]
    if major_id.blank?
      return render :text => "未选择专业"
    end
    begin
      success = Dispatch.dispatch(major_id)
      if success
        redirect_to :action => 'index', :id => major_id
      else
        render :text => "批量分班失败"
      end
    rescue => error
      render :text => error.to_s
    end
  end
end
