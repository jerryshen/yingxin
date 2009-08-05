class ComplexesController < ApplicationController
  require "fastercsv"
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

  def export
    @students = Student.find(:all, :joins => "INNER JOIN proces p ON students.id = p.student_id", :conditions => ["p.step1 =? AND p.step2 = ?", true, false])

    csv_string = FasterCSV.generate do |csv|
      csv << [convert("考生号"),convert("姓名"),convert("院系"),convert("专业")]
      @students.each do |u|
        csv << [convert(u.can_number), convert(u.name), convert(u.major.department.name), convert(u.major.name)]
      end
    end
    send_data csv_string,
      :type=>'text/csv; charset=utf-8; header=present',
      :disposition => "attachment; filename=报到却未缴费学生.csv"
  end

  private

  def get_json
    load_page_data

    conditions = "1=1"
    condition_values = []
    if(!params[:department_id].blank?)
      joins = ""
      conditions += " AND department_id = ? "
      condition_values << params[:department_id]
    end

    if(!params[:major_id].blank?)
      joins = ""
      conditions += " AND major_id = ? "
      condition_values << params[:major_id]
    end

    if(!params[:class_id].blank?)
      joins = ""
      conditions += " AND info_class_id = ? "
      condition_values << params[:class_id]
    end

    if(!params[:search_gender].blank?)
      joins = ""
      conditions += " AND gender = ? "
      condition_values << params[:search_gender]
    end

    if(!params[:search_polity].blank?)
      joins = ""
      conditions += " AND polity = ? "
      condition_values << params[:search_polity]
    end

    if(!params[:search_nation].blank?)
      joins = ""
      conditions += " AND nation = ? "
      condition_values << params[:search_nation]
    end

    if(!params[:search_number].blank?)
      joins = ""
      conditions += " AND stu_number = ? "
      condition_values << params[:search_number]
    end

    if(!params[:search_name].blank?)
      joins = ""
      conditions += " AND name like ? "
      condition_values << "%#{params[:search_name]}%"
    end

    if(!params[:search][:state].blank?)
      joins = ""
      conditions += " AND state = ? "
      condition_values << params[:search][:state]
    end

    if(!params[:search][:city].blank?)
      joins = ""
      conditions += " AND city = ? "
      condition_values << params[:search][:city]
    end

    if(!params[:search_proce].blank?)
      value = (params[:search_proce] == "true" ? true : false)
      conditions += " AND confirm =?"
      condition_values << value
    end

    if(!params[:search_fee].blank?)
      joins = "INNER JOIN proces p ON students.id = p.student_id"
      value = (params[:search_fee] == "true" ? true : false)

      conditions += " AND p.step1 = ? AND p.step2 = ? "
      condition_values << [true, value]
    end

    if(conditions != "1=1")
      option_conditions = [conditions,condition_values].flatten!
      @complexes = Student.paginate(:order =>"id ASC", :joins => joins, :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = Student.count(:joins => joins, :conditions => option_conditions)
    else
      @complexes = Student.paginate(:order =>"id ASC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = Student.count
    end
    return render_json(@complexes,count)
  end
  
end
