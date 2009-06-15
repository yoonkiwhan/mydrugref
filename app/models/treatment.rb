class Treatment < Post
 acts_as_taggable
 validates_presence_of :name

def self.today
    Treatment.find(:all,
                       :conditions =>["type = 'Treatment' and created_at between ? AND ?", Time.today, Time.now],
                       :order => "created_at DESC")
end

def self.cemois
    Treatment.find(:all,
                 :conditions =>["type = 'Treatment' and created_at between ? AND ?", Time.now.at_beginning_of_month, Time.now],
                 :order => "created_at DESC")
end
  
def self.latest
    Treatment.find(:all, :order => "created_at DESC", :limit => 10)
 end

end
