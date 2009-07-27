class StatsController < ApplicationController

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stats }
      format.json { render :text => total_count }
    end
  end

  private

  def total_count
    load_page_data

    department_id = params[:search_department_id]
    if(!department_id.blank?)
      @stats = Stat.get_detail_data(department_id).paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = Stat.get_detail_data(department_id).count
    else
      @stats = Stat.get_detail_data("").paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = Stat.get_detail_data("").count
    end
    return hash_to_json(@stats,count)
  end
end
