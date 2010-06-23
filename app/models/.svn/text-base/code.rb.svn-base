class Code < ActiveRecord::Base
set_table_name "cd_therapeutic_class"
set_primary_key "tc_atc_number"

# belongs_to :drug, :foreign_key => "drug_code"

  def drug
    Drug.find_by_drug_code(self.drug_code)
  end
  
  def active_ingredients
    ActiveIngredient.find_all_by_drug_code(self.drug_code)
  end
 
end
