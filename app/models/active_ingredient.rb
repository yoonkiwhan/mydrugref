class ActiveIngredient < ActiveRecord::Base
set_table_name "cd_active_ingredients"
acts_as_ferret
belongs_to :drug, :foreign_key => "drug_code"

end