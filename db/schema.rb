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

ActiveRecord::Schema.define(:version => 20090604155610) do

  create_table "attachments", :force => true do |t|
    t.binary   "content"
    t.datetime "updated_at"
  end

  create_table "cd2_companies", :id => false, :force => true do |t|
    t.string  "mfr_code",        :limit => 5
    t.integer "company_code"
    t.string  "company_name",    :limit => 80
    t.string  "company_type",    :limit => 40
    t.string  "suite_number",    :limit => 20
    t.string  "street_name",     :limit => 80
    t.string  "city_name",       :limit => 60
    t.string  "province",        :limit => 40
    t.string  "country",         :limit => 40
    t.string  "postal_code",     :limit => 20
    t.string  "post_office_box", :limit => 15
  end

  create_table "cd_active_ingredients", :id => false, :force => true do |t|
    t.integer "drug_code"
    t.integer "active_ingredient_code"
    t.string  "ingredient",              :limit => 240
    t.string  "ingredient_supplied_ind", :limit => 1
    t.string  "strength",                :limit => 20
    t.string  "strength_unit",           :limit => 40
    t.string  "strength_type",           :limit => 40
    t.string  "dosage_value",            :limit => 20
    t.string  "base",                    :limit => 1
    t.string  "dosage_unit",             :limit => 40
    t.text    "notes"
  end

  create_table "cd_companies", :id => false, :force => true do |t|
    t.integer "drug_code"
    t.string  "mfr_code",                  :limit => 5
    t.integer "company_code"
    t.string  "company_name",              :limit => 80
    t.string  "company_type",              :limit => 40
    t.string  "address_mailing_flag",      :limit => 1
    t.string  "address_billing_flag",      :limit => 1
    t.string  "address_notification_flag", :limit => 1
    t.string  "address_other",             :limit => 20
    t.string  "suite_number",              :limit => 20
    t.string  "street_name",               :limit => 80
    t.string  "city_name",                 :limit => 60
    t.string  "province",                  :limit => 40
    t.string  "country",                   :limit => 40
    t.string  "postal_code",               :limit => 20
    t.string  "post_office_box",           :limit => 15
  end

  add_index "cd_companies", ["drug_code"], :name => "cd_company_drug_code_idx"

  create_table "cd_drug_product", :id => false, :force => true do |t|
    t.integer "drug_code"
    t.string  "product_categorization",     :limit => 80
    t.string  "class_1",                    :limit => 40
    t.string  "drug_identification_number", :limit => 8
    t.string  "brand_name",                 :limit => 200
    t.string  "gp_flag",                    :limit => 1
    t.string  "accession_number",           :limit => 5
    t.string  "number_of_ais",              :limit => 10
    t.date    "last_update_date"
    t.string  "ai_group_no",                :limit => 10
    t.integer "company_code"
  end

  add_index "cd_drug_product", ["drug_code"], :name => "cd_drug_code_idx"

  create_table "cd_drug_search", :force => true do |t|
    t.string  "drug_code", :limit => 30
    t.integer "category"
    t.text    "name"
  end

  add_index "cd_drug_search", ["name"], :name => "index_cd_drug_search_on_name"

  create_table "cd_drug_status", :id => false, :force => true do |t|
    t.integer "drug_code"
    t.string  "current_status_flag", :limit => 1
    t.string  "status",              :limit => 40
    t.date    "history_date"
  end

  create_table "cd_form", :id => false, :force => true do |t|
    t.integer "drug_code"
    t.integer "pharm_cd_form_code"
    t.string  "pharmaceutical_cd_form", :limit => 40
  end

  create_table "cd_inactive_products", :id => false, :force => true do |t|
    t.integer "drug_code"
    t.string  "drug_identification_number", :limit => 8
    t.string  "brand_name",                 :limit => 200
    t.date    "history_date"
  end

  create_table "cd_packaging", :id => false, :force => true do |t|
    t.integer "drug_code"
    t.string  "upc",                :limit => 12
    t.string  "package_size_unit",  :limit => 40
    t.string  "package_type",       :limit => 40
    t.string  "package_size",       :limit => 5
    t.string  "product_inforation", :limit => 80
  end

  create_table "cd_pharmaceutical_std", :id => false, :force => true do |t|
    t.integer "drug_code"
    t.string  "pharmaceutical_std", :limit => 40
  end

  create_table "cd_route", :id => false, :force => true do |t|
    t.integer "drug_code"
    t.integer "route_of_administration_code"
    t.string  "route_of_administration",      :limit => 40
  end

  create_table "cd_schedule", :id => false, :force => true do |t|
    t.integer "drug_code"
    t.string  "schedule",  :limit => 40
  end

  create_table "cd_therapeutic_class", :id => false, :force => true do |t|
    t.integer "drug_code"
    t.string  "tc_atc_number",  :limit => 8
    t.string  "tc_atc",         :limit => 120
    t.string  "tc_ahfs_number", :limit => 20
    t.string  "tc_ahfs",        :limit => 80
  end

  add_index "cd_therapeutic_class", ["tc_atc", "tc_atc_number"], :name => "index_cd_therapeutic_class_on_tc_atc_number_and_tc_atc"

  create_table "cd_veterinary_species", :id => false, :force => true do |t|
    t.integer "drug_code"
    t.string  "vet_species",     :limit => 80
    t.string  "vet_sub_species", :limit => 80
  end

  create_table "drug_refs", :force => true do |t|
    t.string  "drug_identification_number"
    t.integer "post_id"
    t.string  "label"
    t.string  "tc_atc_number"
  end

  create_table "friends_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "friend_id"
  end

  create_table "link_generic_brand", :force => true do |t|
    t.string "drug_code", :limit => 30
  end

  create_table "posts", :force => true do |t|
    t.string   "type",         :limit => 20
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.text     "body",                        :default => "",  :null => false
    t.string   "effect",       :limit => 20
    t.string   "evidence",     :limit => 20
    t.string   "reference"
    t.string   "significance"
    t.string   "name",         :limit => 100
    t.boolean  "agree"
    t.string   "news_source"
    t.string   "news_date"
    t.float    "cost",                        :default => 0.0
  end

  add_index "posts", ["created_at"], :name => "created_at"
  add_index "posts", ["post_id"], :name => "post_id"
  add_index "posts", ["type"], :name => "type"
  add_index "posts", ["updated_at"], :name => "updated_at"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "threaded_discussion_posts", :force => true do |t|
    t.integer  "root_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.text     "body",       :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.string   "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email",           :limit => 100, :default => "",    :null => false
    t.string   "name",            :limit => 40,  :default => "",    :null => false
    t.integer  "picture_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",          :limit => 50,  :default => "",    :null => false
    t.datetime "last_active"
    t.boolean  "admin",                          :default => false, :null => false
    t.string   "hashed_password",                :default => "",    :null => false
    t.string   "salt",                           :default => "",    :null => false
    t.integer  "added_by"
  end

  add_index "users", ["email"], :name => "email", :unique => true

end
