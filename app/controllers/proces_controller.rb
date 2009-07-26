class ProcesController < ApplicationController

  def index
    @proces = Proce.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @proces }
      format.json { render :text => get_json }
    end
  end

  private

  def get_json
    load_page_data

    joins = "INNER JOIN students p ON proces.student_id=p.id"
    conditions = "1=1"
    condition_values = []
    if(!params[:department_id].blank?)
      conditions += " AND p.department_id = ? "
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

    if(!params[:search_name].blank?)
      students = Student.find(:all, :conditions => ["name like ?", "%#{params[:search_name]}%"])
      ids = []
      unless students.blank?
        students.each do |u|
          ids.push(u.id)
        end
      end
      idss = ids.join(",")
      conditions += " AND p.id in (#{idss})"
      condition_values << []
    end

    if(!params[:search_can_number].blank?)
      conditions += " AND p.can_number = ?"
      condition_values << params[:search_can_number]
    end

    if(conditions != "1=1")
      option_conditions = [conditions,condition_values].flatten!
      @proces = Proce.paginate(:order =>"id DESC", :joins => joins,:conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count(:joins => joins, :conditions => option_conditions)
    else
      @proces = Proce.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count
    end
    return render_json(@proces,count)
  end
end
