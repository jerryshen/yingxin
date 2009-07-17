module DispatchesHelper
    def list_majors
    @options = [["所有",""]]
    Department.find_by_sql("select id,name from majors").each do |row|
      ar=[]
      ar << row.attributes["name"].to_s
      ar << row.attributes["id"].to_s
      @options << ar
    end
  end
end
