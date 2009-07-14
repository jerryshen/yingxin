module PagesHelper
  #select option for index searching
  def list_page_modules_for_search
    @options = [["所有",""]]
    Department.find_by_sql("select id,name from page_modules").each do |row|
      ar=[]
      ar << row.attributes["name"].to_s
      ar << row.attributes["id"].to_s
      @options << ar
    end
  end
end
