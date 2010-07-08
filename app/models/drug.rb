class Drug < ActiveRecord::Base
  set_table_name "cd_drug_product"
  set_primary_key "drug_identification_number"

  # has_one :code, :foreign_key => "drug_code"
  # has_one :company, :foreign_key => "drug_code"
  # has_many :active_ingredient, :foreign_key => "drug_code"
  has_many :drug_refs, :foreign_key => "drug_identification_number"
  has_many :posts, :through => :drug_refs
  validates_numericality_of :drug_code

  def active_ingredients
    ActiveIngredient.find_all_by_drug_code(self.drug_code)
  end

  def atc
    self.code.tc_atc_number
  end

  def code
    Code.find_by_drug_code(self.drug_code)
  end

  def company
    Company.find_by_drug_code(self.drug_code)
  end

  def self.find_all_by_atc(atc)
    codes = Code.find_all_by_tc_atc_number(atc)
    codes.map {|c| c.drug }
  end

end
#http://216.176.50.202/formulary/SearchServlet?searchType=singleQuery&keywords=02242929
