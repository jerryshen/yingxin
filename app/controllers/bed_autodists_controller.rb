class BedAutodistsController < ApplicationController
  # GET /bed_autodists
  # GET /bed_autodists.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bed_autodists }
      format.json { render :text => get_json }
    end
  end

  # GET /bed_autodists/1
  # GET /bed_autodists/1.xml
  def show
    @bed_autodist = Student.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bed_autodist }
    end
  end

    private

  def get_json
    load_page_data

    conditions = '1=1'
    condition_values = []
    if(!params[:department_id].blank?)
      conditions += " AND department_id = ? "
      condition_values << params[:department_id]
    end

    if(!params[:major_id].blank?)
      conditions += " AND major_id = ? "
      condition_values << params[:major_id]
    end

    if(!params[:class_id].blank?)
      conditions += " AND info_class_id = ? "
      condition_values << params[:class_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @bed_autodists = Student.paginate(:order =>"id ASC", :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = Student.count(:conditions => option_conditions)
    else
      @bed_autodists = Student.paginate(:order =>"id ASC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = Student.count
    end
    return render_json(@bed_autodists,count)
  end

end
