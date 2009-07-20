class WelcomeController < ApplicationController
  def index
    @tips = Tip.find(:all, :conditions => {:hidden => false}, :order => "top ASC, id DESC")
  end
end
