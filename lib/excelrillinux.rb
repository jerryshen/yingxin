require 'spreadsheet'
require 'iconv'
module ExcelRill
  def self.get_rows_count(sheet)
    sheet.row_count
  end
  
  def self.get_cols_count(sheet)
    sheet.column_count
  end
  
	def self.get_area_data(sheet, option)    
		rows = sheet.row_count
		cols = sheet.column_count

		default = {:start_row => 1,:start_column=> 1, :end_row => -1, :end_column => -1}
		option = default.merge!(option)

    raise "�������Χ���󣺿�ʼ�кű�����ڵ���0" unless option[:start_row] >= 0
    raise "�������Χ���󣺿�ʼ�кű�����ڵ���0" unless option[:start_column] >= 0

		startRow = option[:start_row] 
		startCol = option[:start_column] 
		endRow = rows + option[:end_row] + 1 
		endCol = cols + option[:end_column] + 1

    raise "�������Χ���󣺽����к�#{endROw}������ʼ�к�#{startRow}" unless endRow >= startRow
    raise "�������Χ���󣺽����к�#{endCol}������ʼ�к�#{startCol}" unless endCol >= startCol

		data = []
		for row in startRow..endRow
		  row_data = data[data.length] = []      
		  for col in startCol..endCol 
        row_data << sheet.row(row)[col]
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
          #hashRow[key] = Iconv.iconv("UTF-8//IGNORE","GB2312//IGNORE",dataRow[col].to_s)
          hashRow[key] = dataRow[col].to_s
        else
          key = "��#{col}��"
          hashRow[key] = dataRow[col].to_s
          #raise "��#{col}�е�key������"
        end
		  end
		end
		return hashdata
	end

  #��ȡĳ��Ԫ���ֵ
  def self.get_cell_value(sheet,row,col)
    return sheet.row(row)[col]
  end

  def self.parse_excel(file_path,blocks,*encoding)
    raise "�ļ�������" unless File.exist?(file_path)
		workbook = Spreadsheet.open(file_path)
    unless(encoding.length > 0)
      Spreadsheet.client_encoding = encoding[0]
    end
    begin
      blocks.each{ |proc| proc.call(workbook)}
		rescue => error
      raise error
		ensure
      #some operate
		end
  end


  def self.parse_sheet(workbook,index,blocks)
    sheet = workbook.worksheet(index)
    blocks.each{|proc| proc.call(sheet)}
    sheet = nil
  end
end
