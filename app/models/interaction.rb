class Interaction < Post
validate :has_affecting_and_affected

 def has_affecting_and_affected
   if drug_refs.length < 2 or (!both_there)
     errors.add(:drug_refs, "Must have at least one ATC Code for the affecting drug and one ATC Code for the affected drug.")
   end
 end
 
 def both_there
  affecting = false
  affected = false
  drug_refs.each do |d|
    # 5 attributes means the DrugRef is marked for deletion
    if !(d.marked_for_destruction?) and d.label == 'int_drug1'
      affecting = true
    elsif !(d.marked_for_destruction?) and d.label == 'int_drug2'
      affected = true
    end
  end
  return (affecting and affected)
 end

 def affecting_dr
   self.drug_refs.detect {|d| d.label == 'int_drug1'}
 end
 
 def affected_dr
   self.drug_refs.detect {|d| d.label == 'int_drug2'}
 end

 def affecting_drug
   self.drug_refs.detect {|d| d.label == 'int_drug1'}.drug
 end
 
 def affected_drug
   self.drug_refs.detect {|d| d.label == 'int_drug2'}.drug
 end
  
end
