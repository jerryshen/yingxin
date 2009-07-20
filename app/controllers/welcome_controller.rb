class WelcomeController < ApplicationController
  def index
    @tips = Tip.find(:all, :conditions => {:hidden => false}, :order => "top DESC, id DESC")
  end
end
