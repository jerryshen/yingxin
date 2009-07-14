require 'win32ole'
require 'iconv'
module ExcelRill
	def self.get_area_data(sheet, option)    
		rows = sheet.UsedRange.Rows.count
		cols = sheet.UsedRange.columns.count

		default = {:start_row => 1,:start_column=> 1, :end_row => -1, :end_column => -1}
		option = default.merge!(option)

    raise "数据区域范围错误：开始行号必须大于等于0" unless option[:start_row] >= 0
    raise "数据区域范围错误：开始列号必须大于等于0" unless option[:start_column] >= 0

		startRow = option[:start_row] 
		startCol = option[:start_column] 
		endRow = rows + option[:end_row] 
		endCol = cols + option[:end_column]

    raise "数据区域范围错误：结束行号#{endROw}大于起始行号#{startRow}" unless endRow >= startRow
    raise "数据区域范围错误：结束列号#{endCol}大于起始列号#{startCol}" unless endCol >= startCol

		data = []
		for row in startRow..endRow
		  row_data = data[data.length] = []      
		  for col in startCol..endCol 
        row_data << self.get_cell_value(sheet, row, col)
		  end
		end
		return data
	end

	def self.convert_to_hash(data,keys)
		hashdata = []
		data.each_index do |row|
		  hashRow = hashdata[row] = {}
		  dataRow = data[row]
		  dataRow.each_index do |col|
        if key = keys[col]
          begin
            hashRow[key] = Iconv.iconv("UTF-8//IGNORE","GBK//IGNORE",dataRow[col].to_s)[0]
          rescue 
            hashRow[key] = ""
          end
        else
          raise "第#{col}列的key不存在"
        end
		  end
		end
		return hashdata
	end

  #获取某个单元格的值
  def self.get_cell_value(sheet,row,col)
    return sheet.Cells(row+1,col+1).value
  end

  def self.parse_excel(file_path,blocks,*encoding) #第三个参数只是为了与excelrillinux接口一致
    raise "文件不存在" unless File.exist?(file_path)
    excel = WIN32OLE::new('excel.Application')
		excel.visible = false     # in case you want to see what happens 
		excel.Application.DisplayAlerts = false
		workbook = excel.Workbooks.Open(file_path)
    begin
      blocks.each{ |proc| proc.call(workbook)}
		rescue => error
      #raise error
		ensure
      workbook.Close
		  excel.Workbooks.Close
		  excel.Quit
		end
  end


  def self.parse_sheet(workbook,index,blocks)
    sheet = workbook.Worksheets(index + 1)
    sheet.Select
    blocks.each{|proc| proc.call(sheet)}
    sheet = nil
  end
end
