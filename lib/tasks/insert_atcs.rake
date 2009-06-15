task :insert_atcs => :environment do
  for dr in DrugRef.all
    dr.update_attribute(:tc_atc_number, dr.drug.code.tc_atc_number)
  end
end