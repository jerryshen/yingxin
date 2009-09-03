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

  def export_no_fee
    filename = "未缴费学生列表（已报到）"
    @students = Student.find(:all, :joins => "INNER JOIN proces p ON students.id = p.student_id", :conditions => ["p.step1 =? AND p.step2 = ?", true, false])
    data_export(@students,filename)
  end

  def export_confirm_true
    filename = "已报到学生列表"
    @students = Student.find(:all, :joins => "INNER JOIN proces p ON students.id = p.student_id", :conditions => ["p.step1 =?", true])
    data_export(@students,filename)
  end

  def export_no_signup
    filename = "未报到学生列表"
    @students = Student.find(:all, :conditions => ["confirm = ?", false])
    data_export(@students,filename)
  end

  def export_green_path
    filename = "绿色通道学生列表"
    @students = Student.find(:all, :joins => "INNER JOIN proces p ON students.id = p.student_id", :conditions => ["p.step1 = ? AND p.remit = ?", true, true])
    data_export(@students,filename)
  end

  private

  def data_export(students,filename)
    csv_string = FasterCSV.generate do |csv|
      csv << [convert("考生号"),convert("姓名"),convert("身份证号"),convert("出生年月"),convert("性别"),convert("院系"),convert("专业")]
      students.each do |u|
        csv << [u.can_number, convert(u.name), u.id_number, format_birth(u.birthday), convert(format_gender(u.gender)), convert(u.major.department.name), convert(u.major.name)]
      end
    end
    send_data csv_string,
      :type=>'text/csv; charset=utf-8; header=present',
      :disposition => "attachment; filename=#{convert(filename)}.csv"
  end

  def get_json
    load_page_data

    conditions = "1=1"
    condition_values = []
    if(!params[:department_id].blank?)
      majors = Department.find(params[:department_id]).majors
      ids = []
      unless majors.blank?
        majors.each do |m|
          ids.push(m.id)
        end
      end
      idss = ids.join(",")
      conditions += " AND major_id in (#{idss}) "
      condition_values << []
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
      conditions += " AND can_number = ? "
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
      case params[:search_fee]
      when "0"
        value = true
        conditions += " AND p.step1 = ? AND p.step2 = ?"
      when "1"
        value = true
        conditions += " AND p.step1 = ? AND p.remit = ?"
      when "2"
        value = false
        conditions += " AND p.step1 = ? AND p.step2 = ?"
      end
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
