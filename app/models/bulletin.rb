class Bulletin < Post
  
  def self.today
    Bulletin.find(:all,
                       :conditions =>["type = 'Bulletin' and created_at between ? AND ?", Time.today, Time.now],
                       :order => "created_at DESC")
  end
  
  def self.cemois
    Bulletin.find(:all,
                 :conditions =>["type = 'Bulletin' and created_at between ? AND ?", Time.now.at_beginning_of_month, Time.now],
                 :order => "created_at DESC")
  end
 
 def self.latest
    Bulletin.find(:all, :order => "created_at DESC", :limit => 10)
 end
  
end
