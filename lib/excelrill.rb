require 'win32ole'
require 'iconv'
module ExcelRill
  def self.get_rows_count(sheet)
    sheet.UsedRange.Rows.count
  end
  
  def self.get_cols_count(sheet)
    sheet.UsedRange.columns.count
  end
  
	def self.get_area_data(sheet, option)    
		rows = sheet.UsedRange.Rows.count
		cols = sheet.UsedRange.columns.count

		default = {:start_row => 1,:start_column=> 1, :end_row => -1, :end_column => -1}
		option = default.merge!(option)

    raise "�������Χ���󣺿�ʼ�кű�����ڵ���0" unless option[:start_row] >= 0
    raise "�������Χ���󣺿�ʼ�кű�����ڵ���0" unless option[:start_column] >= 0

		startRow = option[:start_row] 
		startCol = option[:start_column] 
		endRow = rows + option[:end_row] 
		endCol = cols + option[:end_column]

    raise "�������Χ���󣺽����к�#{endROw}������ʼ�к�#{startRow}" unless endRow >= startRow
    raise "�������Χ���󣺽����к�#{endCol}������ʼ�к�#{startCol}" unless endCol >= startCol
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
          raise "��#{col}�е�key������"
        end
		  end
		end
		return hashdata
	end

  #��ȡĳ��Ԫ���ֵ
  def self.get_cell_value(sheet,row,col)
    return sheet.Cells(row+1,col+1).value
  end

  def self.parse_excel(file_path,blocks,*encoding) #��������ֻ��Ϊ����excelrillinux�ӿ�һ��
    raise "�ļ�������" unless File.exist?(file_path)
    excel = WIN32OLE::new('excel.Application')
		excel.visible = false     # in case you want to see what happens 
		excel.Application.DisplayAlerts = false
		workbook = excel.Workbooks.Open(file_path)
    begin
      blocks.each{ |proc| proc.call(workbook)}
		rescue => error
      raise error
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
