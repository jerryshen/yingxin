# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 27) do

  create_table "app_configs", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "beds", :force => true do |t|
    t.integer  "number"
    t.integer  "room_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "beds", ["room_id"], :name => "index_beds_on_room_id"
  add_index "beds", ["student_id"], :name => "index_beds_on_student_id"

  create_table "buildings", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.boolean  "de_type",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fee_stds", :force => true do |t|
    t.integer  "major_id"
    t.float    "fee1"
    t.float    "fee2"
    t.float    "fee3"
    t.float    "other",      :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fee_stds", ["major_id"], :name => "index_fee_stds_on_major_id"

  create_table "info_classes", :force => true do |t|
    t.integer  "major_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "majors", :force => true do |t|
    t.integer  "department_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "majors", ["department_id"], :name => "index_majors_on_department_id"

  create_table "page_modules", :force => true do |t|
    t.string   "name"
    t.string   "icon"
    t.integer  "index"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_roles", :force => true do |t|
    t.integer  "page_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_roles", ["page_id"], :name => "index_page_roles_on_page_id"
  add_index "page_roles", ["role_id"], :name => "index_page_roles_on_role_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.text     "function"
    t.string   "url"
    t.integer  "index"
    t.string   "icon"
    t.integer  "page_module_id"
    t.boolean  "hidden",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["page_module_id"], :name => "index_pages_on_page_module_id"

  create_table "proces", :force => true do |t|
    t.integer  "student_id"
    t.boolean  "step1",      :default => false
    t.boolean  "step2",      :default => false
    t.boolean  "step3",      :default => false
    t.boolean  "step4",      :default => false
    t.boolean  "step5",      :default => false
    t.boolean  "step6",      :default => false
    t.boolean  "step7",      :default => false
    t.datetime "step1_date"
    t.datetime "step2_date"
    t.datetime "step3_date"
    t.datetime "step4_date"
    t.datetime "step5_date"
    t.datetime "step6_date"
    t.datetime "step7_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "proces", ["student_id"], :name => "index_proces_on_student_id"

  create_table "role_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "role_users", ["role_id"], :name => "index_role_users_on_role_id"
  add_index "role_users", ["user_id"], :name => "index_role_users_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rooms", :force => true do |t|
    t.integer  "building_id"
    t.integer  "info_class_id"
    t.integer  "student_id"
    t.string   "name"
    t.integer  "bed_count"
    t.string   "phone"
    t.integer  "room_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rooms", ["building_id"], :name => "index_rooms_on_building_id"
  add_index "rooms", ["info_class_id"], :name => "index_rooms_on_info_class_id"
  add_index "rooms", ["student_id"], :name => "index_rooms_on_student_id"

  create_table "students", :force => true do |t|
    t.string   "can_number"
    t.string   "exa_number"
    t.string   "stu_number"
    t.string   "name"
    t.float    "h_score"
    t.float    "r_score"
    t.integer  "polity"
    t.integer  "department_id"
    t.integer  "major_id"
    t.integer  "info_class_id"
    t.string   "direction"
    t.string   "id_number"
    t.string   "gender"
    t.string   "nation"
    t.string   "region"
    t.datetime "entrance_date"
    t.integer  "stu_type"
    t.integer  "gra_type"
    t.string   "school_code"
    t.string   "school_name"
    t.string   "edu_length"
    t.string   "post_code"
    t.datetime "birthday"
    t.string   "address"
    t.string   "state"
    t.string   "city"
    t.string   "region_code"
    t.string   "region_name"
    t.string   "rec_addr"
    t.string   "receiver"
    t.text     "description"
    t.string   "thumb"
    t.string   "phone"
    t.boolean  "confirm",       :default => false
    t.datetime "confirm_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "students", ["department_id"], :name => "index_students_on_department_id"
  add_index "students", ["info_class_id"], :name => "index_students_on_info_class_id"
  add_index "students", ["major_id"], :name => "index_students_on_major_id"

  create_table "subjects", :force => true do |t|
    t.string   "name"
    t.integer  "index"
    t.string   "addr"
    t.string   "department"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temps", :force => true do |t|
    t.string   "name"
    t.string   "f1"
    t.string   "f2"
    t.string   "f3"
    t.string   "f4"
    t.float    "f5"
    t.float    "f6"
    t.string   "f7"
    t.string   "f8"
    t.string   "f9"
    t.string   "f10"
    t.string   "f11"
    t.string   "f12"
    t.string   "f13"
    t.string   "f14"
    t.string   "f15"
    t.string   "f16"
    t.string   "f17"
    t.string   "f18"
    t.string   "f19"
    t.string   "f20"
    t.string   "f21"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tips", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.text     "content"
    t.boolean  "top",        :default => false
    t.boolean  "hidden",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tips", ["user_id"], :name => "index_tips_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "department_id"
    t.string   "gender"
    t.string   "login_id"
    t.string   "password"
    t.string   "theme"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["department_id"], :name => "index_users_on_department_id"

end
