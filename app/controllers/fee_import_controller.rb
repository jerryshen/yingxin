class FeeImportController < ApplicationController
  def index
  end

  def import
    n = FeeTemp.import(params[:myform][:file])  
    if n > 0
      redirect_to :controller => "FeeTemps", :action => "index"
    else
      render :index
    end
  end
end
