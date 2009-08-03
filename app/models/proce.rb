class Proce < ActiveRecord::Base
  belongs_to :student

  before_update :re_verify

  # the first step is ness.
  def re_verify
    raise "can't pass" if self.step1 == false
  end

end
