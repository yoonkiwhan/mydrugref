class Price < Post
 # belongs_to :post
  validates_numericality_of :cost

end