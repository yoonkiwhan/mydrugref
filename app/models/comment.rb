class Comment < Post
  belongs_to :post
  acts_as_ferret
  
  
  def self.tally
    count("agree=true")
  end
  
  def self.tally2
    count(:conditions => "goat=true")
  end
  
  def self.tally3
    count("vote='yea'")
  end
    
  def self.fifty
    percent = post.comments.tally2 * (100 / post.comments.count)
    if percent >= 50
      return true
    else
      return false
    end
  end
  
end
