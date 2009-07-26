class InfoClass < ActiveRecord::Base
  belongs_to :major
  has_many :students

  def self.to_json
    hash = {}
    find_by_sql("select id,name from info_classes").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash.to_json
  end


  def students_to_json
    ar_classes = self.students.collect do |row|
      {:id => row.id, :name => row.name}
    end
    ar_classes.to_json
  end
end
