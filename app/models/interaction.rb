class Interaction < Post

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
 
 def self.today
    Interaction.find(:all, :conditions => ["type = 'Interaction' and created_at between ? AND ?", Time.today, Time.now],
                          :order => "created_at DESC")
  end
  
 def self.latest
    Interaction.find(:all, :order => "created_at DESC", :limit => 10)
 end
 
 def self.cemois
    Interaction.find(:all,
                     :conditions =>["type = 'Interaction' and created_at between ? AND ?", Time.now.at_beginning_of_month, Time.now],
                     :order => "created_at DESC")
 end
  
end
