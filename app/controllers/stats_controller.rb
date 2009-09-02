class StatsController < ApplicationController
  protect_from_forgery :except => [:export]
  require "fastercsv"

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stats }
      format.json { render :text => total_count }
    end
  end

  def export_all
    @students = Student.find(:all, :conditions => ["confirm = ?", false])

    csv_string = FasterCSV.generate do |csv|
      csv << [convert("考生号"),convert("姓名"),convert("身份证号"),convert("出生年月"),convert("性别"),convert("院系"),convert("专业")]
      @students.each do |u|
        csv << [convert(u.can_number), convert(u.name), convert(u.id_number), convert(format_birth(u.birthday)), convert(format_gender(u.gender)), convert(u.major.department.name), convert(u.major.name)]
      end
    end
    send_data csv_string,
      :type=>'text/csv; charset=utf-8; header=present',
      :disposition => "attachment; filename=#{convert("未报到学生")}.csv"
  end

  def export
    major = Major.find(params[:major_id])
    @students = Student.find(:all, :conditions => ["major_id = ? AND confirm = ?", major.id, false])
    
    csv_string = FasterCSV.generate do |csv|
      csv << [convert("考生号"),convert("姓名"),convert("身份证号"),convert("出生年月"),convert("性别"),convert("院系"),convert("专业")]
      @students.each do |u|
        csv << [convert(u.can_number), convert(u.name), convert(u.id_number), convert(format_birth(u.birthday)), convert(format_gender(u.gender)), convert(u.major.department.name), convert(u.major.name)]
      end
    end

    send_data csv_string,
      :type=>'text/csv; charset=utf-8; header=present',
      :disposition => "attachment; filename= #{convert(major.name)}#{convert("未报道学生列表")}.csv"
  end
  
  private

  def total_count
    load_page_data

    department_id = params[:search_department_id]
    if(!department_id.blank?)
      @stats = Stat.get_detail_data(department_id).paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = Stat.get_detail_data(department_id).length
    else
      @stats = Stat.get_detail_data("").paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = Stat.get_detail_data("").length
    end
    return hash_to_json(@stats,count)
  end
end
