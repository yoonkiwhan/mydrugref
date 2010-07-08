class Interaction < Post
  validate :has_affecting_and_affected

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

  def has_affecting_and_affected
    if drug_refs.length < 2 or (!both_there)
      errors.add(:drug_refs, 
                 "Must have at least one ATC Code for the affecting drug and one ATC Code for the affected drug.")
    end
  end

  def make_a_name
    # Get first affecting drug_ref (int_drug1) that has a clickable tc_atc (i.e., not blank)
    affecting_drs = self.drug_refs.find_all {|d| d.label == 'int_drug1'}
    affecting_dr = affecting_drs.detect {|d| (!d.code.nil?) and d.code.tc_atc != ''}

    # If one is found, get that tc_atc, otherwise the name will be the ATC Code.
    affecting_drug = (affecting_dr.nil? ? affecting_drs[0].tc_atc_number : affecting_dr.code.tc_atc)

    # Do the same for affected drug_refs
    affected_drs = self.drug_refs.find_all {|d| d.label == 'int_drug2'}
    affected_dr = affected_drs.detect {|d| (!d.code.nil?) and d.code.tc_atc != ''}
    affected_drug = (affected_dr.nil? ? affected_drs[0].tc_atc_number : affected_dr.code.tc_atc)

    return affecting_drug.capitalize + ' and ' + affected_drug.capitalize
  end

  def affecting_dr
    self.drug_refs.detect {|d| d.label == 'int_drug1'}
  end

  def affected_dr
    self.drug_refs.detect {|d| d.label == 'int_drug2'}
  end

end
