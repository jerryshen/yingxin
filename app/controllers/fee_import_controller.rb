class FeeImportController < ApplicationController
  def index
  end

  def import
    if params[:myform][:file].nil?
      return render :text => "未选择导入文件"
    end 
    begin
      n = FeeTemp.import(params[:myform][:file])
      if n > 0
        redirect_to :controller => "fee_temps", :action => "index"
      else
        render :text => "导入数据失败"
      end
    rescue => error
      render :text => error.to_s
    end
  end
end
