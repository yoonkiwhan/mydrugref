class Warning < Post
 
  def self.today
    Warning.find(:all,
                       :conditions =>["type = 'Warning' and created_at between ? AND ?", Time.today, Time.now],
                       :order => "created_at DESC")
  end
  
  def self.cemois
    Warning.find(:all,
                 :conditions =>["type = 'Warning' and created_at between ? AND ?", Time.now.at_beginning_of_month, Time.now],
                 :order => "created_at DESC")
  end
 
 def self.latest
    Warning.find(:all, :order => "created_at DESC", :limit => 10)
 end
 
end
