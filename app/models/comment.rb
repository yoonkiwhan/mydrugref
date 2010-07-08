class Comment < Post
  belongs_to :post
    
  def self.fifty
    percent = post.comments.tally * (100 / post.comments.count)
    if percent >= 50
      return true
    else
      return false
    end
  end
  
  def self.tally
    count(:conditions => "agree=true")
  end
  
end
