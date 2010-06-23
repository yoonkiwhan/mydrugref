task :elongate_ese => :environment do
  for post in Post.all
    if post.effect == 'A'
      post.update_attribute(:effect, 'Augments')
    elsif post.effect == 'I'
      post.update_attribute(:effect, 'Inhibits')
    elsif post.effect == 'N'
      post.update_attribute(:effect, 'No Effect')
    end
    if post.significance == '3'
      post.update_attribute(:significance, 'High')
    elsif post.significance == '2'
      post.update_attribute(:significance, 'Medium')
    elsif post.significance == '1'
      post.update_attribute(:significance, 'Low')
    end
    if post.evidence == 'G'
      post.update_attribute(:evidence, 'Good')
    elsif post.evidence == 'F'
      post.update_attribute(:evidence, 'Fair')
    elsif post.evidence == 'P'
      post.update_attribute(:evidence, 'Poor')
    end
  end
end
