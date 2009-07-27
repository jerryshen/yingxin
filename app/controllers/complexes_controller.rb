class ComplexesController < ApplicationController
  # GET /complexes
  # GET /complexes.xml
  def index
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

    conditions = "1=1"
    condition_values = []
    if(!params[:department_id].blank?)
      conditions += "department_id = ? "
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

    if(!params[:search_gender].blank?)
      conditions += " AND gender = ? "
      condition_values << params[:search_gender]
    end

    if(!params[:search_polity].blank?)
      conditions += " AND polity = ? "
      condition_values << params[:search_polity]
    end

    if(!params[:search_nation].blank?)
      conditions += " AND nation = ? "
      condition_values << params[:search_nation]
    end

    if(!params[:search_number].blank?)
      conditions += " AND stu_number = ? "
      condition_values << params[:search_number]
    end

    if(!params[:search_name].blank?)
      conditions += " AND name like ? "
      condition_values << "%#{params[:search_name]}%"
    end

    if(!params[:search][:state])
      conditions += " AND state = ? "
      condition_values << params[:search][:state]
    end

    if(!params[:search][:city])
      conditions += " AND city = ? "
      condition_values << params[:search][:city]
    end

    if(conditions != "1=1")
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
