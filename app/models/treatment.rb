class Treatment < Post
 acts_as_taggable
 acts_as_ferret
validates_presence_of :fldrug1

def self.full_text_search(q, options = {})
   return nil if q.nil? or q==""
   default_options = {:limit => 10, :page => 1}
   options = default_options.merge options
 
   # get the offset based on what page we're on
   options[:offset] = options[:limit] * (options.delete(:page).to_i-1)
 
   # now do the query with our options
   results = Treatment.find_by_contents(q, options)
   return [results.total_hits, results]
 end

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
