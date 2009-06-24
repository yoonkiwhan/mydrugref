class Treatment < Post
 acts_as_taggable
 validates_presence_of :name

 def drug_of_choice
  flds = self.drug_refs.find_all { |d| d.label.include?('FLD')}
  if flds.empty?
    "None"
  else
    drug_of_choice = flds.detect {|d| d.code.tc_atc != ''}
    drug_of_choice.nil? ? flds[0].tc_atc_number : drug_of_choice.code.tc_atc.capitalize
  end
 end

end
