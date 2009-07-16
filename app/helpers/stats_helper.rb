module StatsHelper
  # list departments for selecting
  def list_departments
    @options = [["所有",""]]
    Department.find_by_sql("select id,name from departments where de_type = 't'").each do |row|
      ar=[]
      ar << row.attributes["name"].to_s
      ar << row.attributes["id"].to_s
      @options << ar
    end
  end
end
