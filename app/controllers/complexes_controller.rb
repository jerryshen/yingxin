class ComplexesController < ApplicationController
  # GET /complexes
  # GET /complexes.xml
  def index
    @complexes = Student.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @complexes }
      format.json { render :text => get_json }
    end
  end

  def show
    @complex = Student.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @complex }
    end
  end

  private

  def get_json
    load_page_data

    conditions = ""
    condition_values = []
    if(!params[:department_id].blank?)
      conditions += "department_id = ? "
      condition_values << params[:department_id]
    end

    if(!params[:major_id].blank?)
      conditions += " AND p.major_id = ? "
      condition_values << params[:major_id]
    end

    if(!params[:class_id].blank?)
      conditions += " AND p.info_class_id = ? "
      condition_values << params[:class_id]
    end

    if(!conditions.blank?)
      option_conditions = [conditions,condition_values].flatten!
      @complexes = Student.paginate(:order =>"id ASC",:conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = Student.count(:conditions => option_conditions)
    else
      @complexes = Student.paginate(:order =>"id ASC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = Student.count
    end
    return render_json(@complexes,count)
  end
  
end
