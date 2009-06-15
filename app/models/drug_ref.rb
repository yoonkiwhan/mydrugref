class DrugRef < ActiveRecord::Base
belongs_to :drug, :foreign_key => "drug_identification_number"
belongs_to :post
belongs_to :code, :foreign_key => "tc_atc_number"

# validates_presence_of :drug_identification_number
# validates_associated :drug

end
