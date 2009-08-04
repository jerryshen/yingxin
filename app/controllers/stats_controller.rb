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
      csv << ["考生号","姓名","院系","专业"]
      @students.each do |u|
        csv << [u.can_number, u.name, u.major.department.name, u.major.name]
      end
    end
    send_data csv_string,
      :type=>'text/csv; charset=utf-8; header=present',
      :disposition => "attachment; filename=未报到学生.csv"
  end

  def export
    major = Major.find(params[:major_id])
    @students = Student.find(:all, :conditions => ["major_id = ? AND confirm = ?", major.id, false])
    

      csv_string = FasterCSV.generate do |csv|
        csv << ["考生号","姓名","专业"]
        @students.each do |u|
          csv << [u.can_number, u.name,  u.major.name]
        end
      end

      send_data csv_string,
        :type=>'text/csv; charset=utf-8; header=present',
        :disposition => "attachment; filename= #{major.name}未报道学生列表.csv"


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
