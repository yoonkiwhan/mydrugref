class InitialSchema < ActiveRecord::Migration
  def self.up
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
    t.string  "strength_typ
  end

  def self.down
  end
end
