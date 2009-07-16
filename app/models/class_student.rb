class ClassStudent < ActiveRecord::Base
  belongs_to :info_class
  belongs_to :student
end
