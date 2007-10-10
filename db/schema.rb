# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 19) do

  create_table "attachments", :force => true do |t|
    t.column "content",    :binary
    t.column "updated_at", :datetime
  end

  create_table "cd2_companies", :id => false, :force => true do |t|
    t.column "mfr_code",        :string,  :limit => 5
    t.column "company_code",    :integer
    t.column "company_name",    :string,  :limit => 80
    t.column "company_type",    :string,  :limit => 40
    t.column "suite_number",    :string,  :limit => 20
    t.column "street_name",     :string,  :limit => 80
    t.column "city_name",       :string,  :limit => 60
    t.column "province",        :string,  :limit => 40
    t.column "country",         :string,  :limit => 40
    t.column "postal_code",     :string,  :limit => 20
    t.column "post_office_box", :string,  :limit => 15
  end

  create_table "cd_active_ingredients", :id => false, :force => true do |t|
    t.column "drug_code",               :integer
    t.column "active_ingredient_code",  :integer
    t.column "ingredient",              :string,  :limit => 240
    t.column "ingredient_supplied_ind", :string,  :limit => 1
    t.column "strength",                :string,  :limit => 20
    t.column "strength_unit",           :string,  :limit => 40
    t.column "strength_type",           :string,  :limit => 40
    t.column "dosage_value",            :string,  :limit => 20
    t.column "base",                    :string,  :limit => 1
    t.column "dosage_unit",             :string,  :limit => 40
    t.column "notes",                   :text
  end

  create_table "cd_companies", :id => false, :force => true do |t|
    t.column "drug_code",                 :integer
    t.column "mfr_code",                  :string,  :limit => 5
    t.column "company_code",              :integer
    t.column "company_name",              :string,  :limit => 80
    t.column "company_type",              :string,  :limit => 40
    t.column "address_mailing_flag",      :string,  :limit => 1
    t.column "address_billing_flag",      :string,  :limit => 1
    t.column "address_notification_flag", :string,  :limit => 1
    t.column "address_other",             :string,  :limit => 20
    t.column "suite_number",              :string,  :limit => 20
    t.column "street_name",               :string,  :limit => 80
    t.column "city_name",                 :string,  :limit => 60
    t.column "province",                  :string,  :limit => 40
    t.column "country",                   :string,  :limit => 40
    t.column "postal_code",               :string,  :limit => 20
    t.column "post_office_box",           :string,  :limit => 15
  end

  add_index "cd_companies", ["drug_code"], :name => "cd_company_drug_code_idx"

  create_table "cd_drug_product", :id => false, :force => true do |t|
    t.column "drug_code",                  :integer
    t.column "product_categorization",     :string,  :limit => 80
    t.column "class",                      :string,  :limit => 40
    t.column "drug_identification_number", :string,  :limit => 8
    t.column "brand_name",                 :string,  :limit => 200
    t.column "gp_flag",                    :string,  :limit => 1
    t.column "accession_number",           :string,  :limit => 5
    t.column "number_of_ais",              :string,  :limit => 10
    t.column "last_update_date",           :date
    t.column "ai_group_no",                :string,  :limit => 10
    t.column "company_code",               :integer
  end

  add_index "cd_drug_product", ["drug_code"], :name => "cd_drug_code_idx"

  create_table "cd_drug_search", :force => true do |t|
    t.column "drug_code", :string,  :limit => 30
    t.column "category",  :integer
    t.column "name",      :text
  end

  add_index "cd_drug_search", ["name"], :name => "index_cd_drug_search_on_name"

  create_table "cd_drug_status", :id => false, :force => true do |t|
    t.column "drug_code",           :integer
    t.column "current_status_flag", :string,  :limit => 1
    t.column "status",              :string,  :limit => 40
    t.column "history_date",        :date
  end

  create_table "cd_form", :id => false, :force => true do |t|
    t.column "drug_code",              :integer
    t.column "pharm_cd_form_code",     :integer
    t.column "pharmaceutical_cd_form", :string,  :limit => 40
  end

  create_table "cd_inactive_products", :id => false, :force => true do |t|
    t.column "drug_code",                  :integer
    t.column "drug_identification_number", :string,  :limit => 8
    t.column "brand_name",                 :string,  :limit => 200
    t.column "history_date",               :date
  end

  create_table "cd_packaging", :id => false, :force => true do |t|
    t.column "drug_code",          :integer
    t.column "upc",                :string,  :limit => 12
    t.column "package_size_unit",  :string,  :limit => 40
    t.column "package_type",       :string,  :limit => 40
    t.column "package_size",       :string,  :limit => 5
    t.column "product_inforation", :string,  :limit => 80
  end

  create_table "cd_pharmaceutical_std", :id => false, :force => true do |t|
    t.column "drug_code",          :integer
    t.column "pharmaceutical_std", :string,  :limit => 40
  end

  create_table "cd_route", :id => false, :force => true do |t|
    t.column "drug_code",                    :integer
    t.column "route_of_administration_code", :integer
    t.column "route_of_administration",      :string,  :limit => 40
  end

  create_table "cd_schedule", :id => false, :force => true do |t|
    t.column "drug_code", :integer
    t.column "schedule",  :string,  :limit => 40
  end

  create_table "cd_therapeutic_class", :id => false, :force => true do |t|
    t.column "drug_code",      :integer
    t.column "tc_atc_number",  :string,  :limit => 8
    t.column "tc_atc",         :string,  :limit => 120
    t.column "tc_ahfs_number", :string,  :limit => 20
    t.column "tc_ahfs",        :string,  :limit => 80
  end

  add_index "cd_therapeutic_class", ["tc_atc_number", "tc_atc"], :name => "index_cd_therapeutic_class_on_tc_atc_number_and_tc_atc"

  create_table "cd_veterinary_species", :id => false, :force => true do |t|
    t.column "drug_code",       :integer
    t.column "vet_species",     :string,  :limit => 80
    t.column "vet_sub_species", :string,  :limit => 80
  end

  create_table "friends_users", :id => false, :force => true do |t|
    t.column "user_id",   :integer
    t.column "friend_id", :integer
  end

  create_table "link_generic_brand", :force => true do |t|
    t.column "drug_code", :string, :limit => 30
  end

  create_table "posts", :force => true do |t|
    t.column "type",                    :string,   :limit => 20
    t.column "post_id",                 :integer
    t.column "created_at",              :datetime
    t.column "updated_at",              :datetime
    t.column "created_by",              :integer
    t.column "updated_by",              :integer
    t.column "body",                    :text,                    :default => "",  :null => false
    t.column "attachment_id",           :integer
    t.column "attachment_filename",     :string
    t.column "attachment_content_type", :string,   :limit => 128
    t.column "attachment_size",         :integer
    t.column "atc",                     :string,   :limit => 10
    t.column "drug2",                   :string,   :limit => 100
    t.column "atc2",                    :string,   :limit => 10
    t.column "effect",                  :string,   :limit => 20
    t.column "evidence",                :string,   :limit => 20
    t.column "reference",               :string
    t.column "significance",            :integer
    t.column "name",                    :string,   :limit => 100
    t.column "goat",                    :boolean
    t.column "fldrug1",                 :string
    t.column "fldrug3",                 :string
    t.column "sldrug1",                 :string
    t.column "sldrug2",                 :string
    t.column "sldrug3",                 :string
    t.column "pregdrug1",               :string
    t.column "pregdrug2",               :string
    t.column "pregdrug3",               :string
    t.column "atc3",                    :string
    t.column "slatc",                   :string
    t.column "slatc2",                  :string
    t.column "slatc3",                  :string
    t.column "pregatc",                 :string
    t.column "pregatc2",                :string
    t.column "pregatc3",                :string
    t.column "news_source",             :string
    t.column "news_date",               :string
    t.column "cost",                    :decimal,                 :default => 0.0
    t.column "din",                     :string
  end

  add_index "posts", ["created_at"], :name => "created_at"
  add_index "posts", ["post_id"], :name => "post_id"
  add_index "posts", ["type"], :name => "type"
  add_index "posts", ["updated_at"], :name => "updated_at"

  create_table "sessions", :force => true do |t|
    t.column "session_id", :string
    t.column "data",       :text
    t.column "updated_at", :datetime
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.column "tag_id",        :integer
    t.column "taggable_id",   :integer
    t.column "taggable_type", :string
    t.column "created_at",    :datetime
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.column "name", :string
  end

  create_table "users", :force => true do |t|
    t.column "email",           :string,   :limit => 100, :default => "",    :null => false
    t.column "name",            :string,   :limit => 40,  :default => "",    :null => false
    t.column "phone",           :string,   :limit => 50,  :default => "",    :null => false
    t.column "address",         :string,   :limit => 50,  :default => "",    :null => false
    t.column "city",            :string,   :limit => 50,  :default => "",    :null => false
    t.column "state",           :string,   :limit => 50,  :default => "",    :null => false
    t.column "zip",             :string,   :limit => 50,  :default => "",    :null => false
    t.column "picture_id",      :integer
    t.column "created_at",      :datetime
    t.column "updated_at",      :datetime
    t.column "status",          :string,   :limit => 50,  :default => "",    :null => false
    t.column "last_active",     :datetime
    t.column "admin",           :boolean,                 :default => false, :null => false
    t.column "hashed_password", :string,                  :default => "",    :null => false
    t.column "salt",            :string,                  :default => "",    :null => false
  end

  add_index "users", ["email"], :name => "email", :unique => true

end
