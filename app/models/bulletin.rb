class Bulletin < Post
  validate :has_drug_ref

  def make_a_name
    first_clickable_tc_atc = self.drug_refs.detect {|d| d.code.tc_atc != ''}
    first_clickable_tc_atc.nil? ? self.drug_refs[0].tc_atc_number : first_clickable_tc_atc.code.tc_atc.capitalize
  end

end
