class Treatment < Post
 acts_as_taggable
validates_presence_of :fldrug1

def self.today
    Treatment.find(:all,
                       :conditions =>["type = 'Treatment' and created_at between ? AND ?", Time.today, Time.now],
                       :order => "created_at DESC",
                       :limit => 10)
  end

end
