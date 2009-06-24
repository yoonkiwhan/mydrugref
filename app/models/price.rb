class Price < Post
  validates_presence_of :cost
  validates_numericality_of :cost
  validate :one_drug_ref
  
  def one_drug_ref
    if drug_refs.empty? or drug_refs[0].marked_for_destruction?
      errors.add(:drug_refs, "Must have one drug attached")
    end
  end
  
  def make_a_name
    'Price of ' + self.drug_refs[0].drug.brand_name.capitalize
  end
  
end

