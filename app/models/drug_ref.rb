class DrugRef < ActiveRecord::Base
  belongs_to :drug, :foreign_key => "drug_identification_number"
  belongs_to :post
  belongs_to :code, :foreign_key => "tc_atc_number"

  # validates_presence_of :drug_identification_number
  # validates_associated :drug
  
  def display_code # Display the ATC code if there is one, else display the DIN.
    if self.code.nil?
      if self.drug.nil?
        "no ATC Code or DIN found"
      else
        "no ATC Code found: DIN is " + self.drug_identification_number.to_s
      end
    else
      self.tc_atc_number
    end
  end

  def display_name 
    # We want to display the ATC category usually, but some drugs in the HCDB 
    # do not have tc_atc_numbers, therefore we should display the Brand Names.
 
    if self.code.nil? # DrugRef has no Code
      if self.drug.nil?
        "No corresponding drug found in Health Canada Database"
      else # DrugRef at least has a Drug
        self.drug.brand_name
      end 
    else # DrugRef has a "Code" (i.e. it has a valid tc_atc_number)
      self.code.tc_atc
    end
  end

end
