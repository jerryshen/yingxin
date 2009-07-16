class StatsController < ApplicationController

  def index
    @stats = Student.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stats }
      format.json { render :text => total_data }
    end
  end

  private

  def total_data
    load_page_data

    department_id = params[:select_department_id]
    if(!department_id.blank?)
      @stats = Stat.search(department_id).paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = Stat.search(department_id)
    else
      @stats = Stat.get_detail_data.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = Stat.get_detail_data.count
    end
    return hash_to_json(@stats,count)
  end

end
