task :add_holbrook => :environment do

  sql = ActiveRecord::Base.connection
  holbrook_interactions = sql.execute "select affectingatc, affectedatc, effect, significance, evidence, comment from holbrook.interactions;"
  entries = holbrook_interactions.entries
  entries.each do |h|
    if h["effect"] == "A" then effect = "Augments"
    elsif h["effect"] == "I" then effect = "Inhibits"
    elsif h["effect"] == "N" then effect = "No Effect"
    else effect = h["effect"]
    end
    
    if h["significance"] == "1" then sig = "Low"
    elsif h["significance"] == "2" then sig = "Medium"
    elsif h["significance"] == "3" then sig = "High"
    else sig = h["significance"]
    end
    
    if h["evidence"] == "G" then ev = "Good"
    elsif h["evidence"] == "F" then ev = "Fair"
    elsif h["evidence"] == "P" then ev = "Poor"
    else ev = h["evidence"]
    end
    
    i = Interaction.new(:effect => effect, :significance => sig, :evidence => ev, :body => h["comment"], 
                        :reference => 'Holbrook Interactions', :created_by => 7, :updated_by => 7)
    i.drug_refs.build(:label => 'int_drug1', :tc_atc_number => h["affectingatc"])
    i.drug_refs.build(:label => 'int_drug2', :tc_atc_number => h["affectedatc"])
    i.save   
  end

end