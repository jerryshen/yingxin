class BedAutodistsController < ApplicationController
  protect_from_forgery :except => :auto_assigning
  # GET /bed_autodists
  # GET /bed_autodists.xml
  def index
    respond_to do |format|
      format.html 
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

  def auto_assigning
    conditions = '1=1'
    condition_values = []
    if(!params[:department_id].blank? and params[:major_id].blank?)
      conditions += " AND students.major_id IN (SELECT id FROM majors WHERE department_id = ?) "
      condition_values << params[:department_id]
    end

    if(!params[:major_id].blank? and params[:class_id].blank?)
      conditions += " AND students.major_id = ? "
      condition_values << params[:major_id]
    end

    unless params[:class_id].blank?
      conditions += " AND students.info_class_id = ? "
      condition_values << params[:class_id]
    end

    unless params[:gender].blank?
      conditions += " AND students.gender = ? "
      condition_values << params[:gender]
    end

    unless params[:name].blank?
      conditions += " AND students.name = ? "
      condition_values << params[:name]
    end

    conditions += " AND beds.id IS NULL "

    sql = ["SELECT students.id AS id FROM students LEFT JOIN beds ON beds.student_id=students.id LEFT JOIN rooms ON beds.room_id=rooms.id LEFT JOIN buildings ON rooms.building_id=buildings.id LEFT JOIN majors ON students.major_id=majors.id LEFT JOIN departments ON majors.department_id=departments.id LEFT JOIN info_classes ON students.info_class_id=info_classes.id WHERE #{conditions}"] + condition_values
    ids = Student.find_by_sql(sql)
    count = Student.auto_assigning_bed(ids)
    render :text => "共查找出#{ids.length}位未安排床位的学生，成功为其中#{count}位学生安排床位。"
  end

    private

  def get_json
    load_page_data

    conditions = '1=1'
    condition_values = []
    if(!params[:department_id].blank? and params[:major_id].blank?)
      conditions += " AND students.major_id IN (SELECT id FROM majors WHERE department_id = ?) "
      condition_values << params[:department_id]
    end

    if(!params[:major_id].blank? and params[:class_id].blank?)
      conditions += " AND students.major_id = ? "
      condition_values << params[:major_id]
    end

    unless params[:class_id].blank?
      conditions += " AND students.info_class_id = ? "
      condition_values << params[:class_id]
    end

    unless params[:gender].blank?
      conditions += " AND students.gender = ? "
      condition_values << params[:gender]
    end

    unless params[:name].blank?
      conditions += " AND students.name = ? "
      condition_values << params[:name]
    end

    unless params[:hasbed].blank?
      v = params[:hasbed] == "0" ? "IS NULL " : "NOT NULL "
      conditions += " AND beds.id " + v
    end

    sql = ["SELECT students.id AS sid,  students.name AS sname, students.stu_number AS sstu_name, students.gender AS sgender, departments.name AS dname, majors.name AS mname, info_classes.name AS iname, beds.number AS bedname, rooms.name AS rname, buildings.name AS bname FROM students LEFT JOIN beds ON beds.student_id=students.id LEFT JOIN rooms ON beds.room_id=rooms.id LEFT JOIN buildings ON rooms.building_id=buildings.id LEFT JOIN majors ON students.major_id=majors.id LEFT JOIN departments ON majors.department_id=departments.id LEFT JOIN info_classes ON students.info_class_id=info_classes.id WHERE #{conditions} ORDER BY students.id ASC"] + condition_values
    @bed_autodists = Student.paginate_by_sql(sql, :per_page=> @pagesize, :page => params[:page] || 1)
    count_sql = ["SELECT count(*) AS count FROM students LEFT JOIN beds ON beds.student_id=students.id LEFT JOIN rooms ON beds.room_id=rooms.id LEFT JOIN buildings ON rooms.building_id=buildings.id LEFT JOIN majors ON students.major_id=majors.id LEFT JOIN departments ON majors.department_id=departments.id LEFT JOIN info_classes ON students.info_class_id=info_classes.id WHERE #{conditions}"] + condition_values
    count = Student.find_by_sql(count_sql)[0].count.to_i
    return render_json(@bed_autodists,count)
  end

end
