require 'excelrill'
#require 'excelrillinux' #winOLE less
require 'file_upload_util'
class DataImport
  def self.collet_excel_data(file)
    succeed = false
    file_path = upload_to_temp_dir(file)
    begin
      succeed = self.parse(file_path)
    rescue => error
      raise error
    ensure
      delete_temp_file(file_path)
    end
    return succeed
  end
  
  def self.parse(file_path)
    headers = %w{KSH ZKZH  XM  XBDM  CSNY  CJ  TDCJ  ZZMMMC  MZMC  KSLBMC  BYLBMC  ZXDM  ZXMC  DQDM  DQMC  SFZH  JTDZ  YZBM  LXDH  SJR LQZY  XZ}
    fields = %w{f1  f2  name  f3  f4  f5  f6  f7  f8  f9  f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21}      
    header_field = {}
    headers.each_index do |i|
       header_field[headers[i]] =  fields[i]
    end
   
    sheet_index = 0
    encoding = "GBK"
    header_row = 0 
    start_row = 1
    end_row = -1
    data = []
    proc_workbook = lambda do |workbook|
      parse_sheet = lambda  do |sheet|
        cols_count = ExcelRill.get_cols_count(sheet)
        rows_count = ExcelRill.get_rows_count(sheet)
        ignore_cols = []
        field_index = {}
        (0...cols_count).each do |col|
          aheader = ExcelRill.get_cell_value(sheet, header_row, col)
          if headers.include?(aheader)
            field_index[col] = header_field[aheader]
          else
            ignore_cols << col
          end
        end
        
        end_row_no = rows_count + end_row
        (start_row...end_row_no).each do |row|
            row_data = {}
            (0...cols_count).each do |col|
              unless ignore_cols.include?(col) #非忽略列
                key = field_index[col]
                value = ExcelRill.get_cell_value(sheet, row, col)
                begin
                  row_data[key] = Iconv.iconv("UTF-8//IGNORE","GBK//IGNORE",value)[0]
                rescue
                  row_data[key] = value
                end
              end
            end
            data << row_data
        end
      end

      ExcelRill.parse_sheet(workbook, sheet_index, [parse_sheet])
    end
    ExcelRill.parse_excel(file_path, [proc_workbook], encoding)
    if data.length > 0
      Temp.create(data)
      return true
    end
  end

  def self.delete_temp_file(path)
    if File.exist?(path)
      File.delete(path)
    end
  end

  def self.upload_to_temp_dir(xls_file)
    ext_name = FileUploadUtil.get_file_ex_name(xls_file)
    if(ext_name == ".xls")
      save_name = FileUploadUtil.make_timestamp_file_name(xls_file)
      save_dir = RAILS_ROOT + '/tmp/import_xls_files'
      #save_dir = "D:" + '/tmp/import_xls_files'
      FileUploadUtil.save_file(xls_file,save_dir,save_name)
    else
      raise "请上传Excel文件(扩展名为.xls)"
    end
    return save_dir + "/" + save_name
  end

  def self.print_data(data)
    as = []
    data.each_index do |i|
      as << "----第#{i+1}条数据----"
      data[i].each_key do |key|
        as << "#{key}: #{data[i][key]}"
      end
    end
    return as.join("\n")
  end
  
end
