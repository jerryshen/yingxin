class InfoClass < ActiveRecord::Base
  belongs_to :major
  has_many :students
end
