class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.string     :can_number   #考生号
      t.string     :exa_number   #准考证号
      t.string     :stu_number   #学号
      t.string     :name         #姓名
      t.float      :h_score      #高考成绩
      t.float      :r_score      #投标成绩
      t.integer    :polity       #政治面貌
      t.references :department   #院系
      t.references :major        #专业
      t.references :info_class   #班级
      t.string     :direction    #教育方向
      t.string     :id_number    #身份证
      t.string     :gender       #性别
      t.string     :nation       #民族
      t.string     :region       #港澳台侨
      t.datetime   :entrance_date #入学时间
      t.integer    :stu_type     #考生类别名称
      t.integer    :gra_type     #毕业类别名称
      t.string     :school_code  #中学代码
      t.string     :school_name  #中学名称
      t.string     :edu_length   #学制
      t.string     :post_code    #邮政编码
      t.datetime   :birthday     #出生边月
      t.string     :address      #联系地址
      t.string     :state        #生源地－省份
      t.string     :city         #生源地－市现
      t.string     :region_code  #地区代码
      t.string     :region_name  #地区名称
      t.string     :rec_addr     #投寄地址
      t.string     :receiver     #收件人
      t.text       :description  #备注
      t.string     :thumb        #照片

      t.timestamps
    end
    add_index :students, :department_id
    add_index :students, :major_id
    add_index :students, :info_class_id
  end

  def self.down
    drop_table :students
  end
end
