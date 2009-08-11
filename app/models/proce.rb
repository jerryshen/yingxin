class Proce < ActiveRecord::Base
  belongs_to :student

  #  before_update :re_verify
  #
  #  # the first step is ness.
  #  def re_verify
  #    raise false if self.step1 == false
  #  end

  def self.get_gender
    hash = {}
    find_by_sql("select id,gender from students").each do |row|
      attrs = row.attributes
      gender = attrs["gender"] == "m" ? "男" : "女"
      hash[attrs["id"]] = gender
    end
    return hash.to_json
  end

  def self.get_major
    hash = {}
    find_by_sql("select s.id, s.major_id, m.name from students s INNER JOIN majors m ON s.major_id = m.id ").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash.to_json
  end

  def self.get_campus
    hash = {}
    find_by_sql("select s.id, s.major_id, m.campus from students s INNER JOIN majors m ON s.major_id = m.id").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["campus"]
    end
    return hash.to_json
  end
end
