task :add_holbrook => :environment do

  sql = ActiveRecord::Base.connection
  holbrook_interactions = sql.execute "select affectingatc, affectedatc, effect, significance, evidence, comment from holbrook.interactions;"
  holbrook_array = holbrook_interactions.result
  holbrook_array.each do |h|
    if h[2] == "A" then effect = "Augments"
    elsif h[2] == "I" then effect = "Inhibits"
    elsif h[2] == "N" then effect = "No Effect"
    else effect = h[2]
    end
    
    if h[3] == "1" then sig = "Low"
    elsif h[3] == "2" then sig = "Medium"
    elsif h[3] == "3" then sig = "High"
    else sig = h[3]
    end
    
    if h[4] == "G" then ev = "Good"
    elsif h[4] == "F" then ev = "Fair"
    elsif h[4] == "P" then ev = "Poor"
    else ev = h[4]
    end
    
    i = Interaction.new(:effect => effect, :significance => sig, :evidence => ev, :body => h[5], 
                        :reference => 'Holbrook Interactions', :created_by => 7, :updated_by => 7)
    i.drug_refs.build(:label => 'int_drug1', :tc_atc_number => h[0])
    i.drug_refs.build(:label => 'int_drug2', :tc_atc_number => h[1])
    i.save   
  end

end