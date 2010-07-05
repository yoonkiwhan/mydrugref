task :add_names => :environment do

posts = Warning.all + Interaction.all + Bulletin.all + Price.all

posts.each do |p|
  p.update_attribute(:name, p.make_a_name)
end

end