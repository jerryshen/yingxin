class FeeStd < ActiveRecord::Base
  belongs_to :major

  def self.to_json
    hash = {}
    find_by_sql("select major_id,SUM(fee1+fee2+fee3+other) fee from fee_stds INNER JOIN majors p ON p.id = major_id ").each do |row|
      attrs = row.attributes
      hash[attrs["major_id"]] = attrs["fee"]
    end
    return hash.to_json
  end
end
