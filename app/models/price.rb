class Price < Post
  validates_presence_of :cost
  validates_numericality_of :cost
  validate :one_drug_ref
  
  def one_drug_ref
    unless drug_refs.length == 1
      errors.add_to_base("Must have one drug attached")
    end
  end
  
end