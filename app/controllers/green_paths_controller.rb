class GreenPathsController < ApplicationController

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @green_paths }
      format.json { render :text => get_json }
    end
  end

  def show
    @green_path = Proce.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @green_path }
    end
  end

  def edit
    @green_path = Proce.find(params[:id])
  end

  def update
    @green_path = Proce.find(params[:id])

    respond_to do |format|
      if @green_path.update_attributes(params[:green_path])
        format.html { redirect_to(@green_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @green_path.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @green_path = Proce.find(params[:id])
    @green_path.destroy

    respond_to do |format|
      format.html { redirect_to(green_paths_url) }
      format.xml  { head :ok }
    end
  end

  def pass
    @green_path = Proce.find(params[:id])
    if @green_path.step1 == true
      if !@green_path.remit
        if @green_path.update_attributes(:remit => true, :remit_date => Time.now, :step2 => true, :step2_date => Time.now)
          Student.proc_end(@green_path)
          render :text =>"true"
        else
          render :text => "false"
        end
      else
        if @green_path.update_attributes(:remit => false, :remit_date => nil, :step2 => false, :step2_date => nil)
          Student.proc_restart(@green_path)
          render :text =>"true"
        else
          render :text => "false"
        end
      end
    else
      render :text => "false"
    end
  end

  private

  def get_json

    load_page_data

    joins = "INNER JOIN students p ON proces.student_id=p.id"
    conditions = '1=1'
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
      conditions += " AND p.major_id in (#{idss}) "
      condition_values << []
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

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @green_paths = Proce.paginate(:order =>"id ASC", :joins => joins,:conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count(:joins => joins, :conditions => option_conditions)
    else
      @green_paths = Proce.paginate(:order =>"id ASC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = Proce.count
    end
    return render_json(@green_paths,count)
  end
end
