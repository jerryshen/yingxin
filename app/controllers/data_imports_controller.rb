class DataImportsController < ApplicationController
  def index
  end

  def import
    if params[:excel_file].nil?
      return render :text => "未选择导入文件"
    end 
    begin
      success = DataImport.collet_excel_data(params[:excel_file])
      if success
          return redirect_to :controller => 'temps', :action => 'index'
      else
        render :text => "导入数据失败"
      end
    rescue => error
      render :text => error.to_s
    end
  end

end
