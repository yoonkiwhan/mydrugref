class ActiveIngredient < ActiveRecord::Base
set_table_name "cd_active_ingredients"

def drug
  Drug.find_by_drug_code(self.drug_code)
end

def code
  Code.find_by_drug_code(self.drug_code)
end

end
