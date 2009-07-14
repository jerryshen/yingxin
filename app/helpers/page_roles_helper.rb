module PageRolesHelper
  #select options for index searching
  def list_pages_for_search
    @options = [["所有",""]]
    Page.find_by_sql("select id,name from pages").each do |row|
      ar=[]
      ar << row.attributes["name"].to_s
      ar << row.attributes["id"].to_s
      @options << ar
    end
  end

  def list_roles_for_search
    @options = [["所有",""]]
    Role.find_by_sql("select id,name from roles").each do |row|
      ar=[]
      ar << row.attributes["name"].to_s
      ar << row.attributes["id"].to_s
      @options << ar
    end
  end
end
