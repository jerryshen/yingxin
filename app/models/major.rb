class Major < ActiveRecord::Base
  belongs_to :department
  has_many :info_classes
  has_many :students


  def classes_to_json
    dep_classes = self.info_classes
    ar_classes = dep_classes.collect do |row|
      {:id => row.id, :name => row.name}
    end
    ar_classes.to_json
  end
  
  def self.to_json
    hash = {}
    find_by_sql("select id,name from majors").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash.to_json
  end

  def self.get_department_name
    hash = {}
    find_by_sql("select m.id,d.name from majors m INNER JOIN departments d ON m.department_id = d.id").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash.to_json
  end
end
