class Drug < ActiveRecord::Base
set_table_name "cd_drug_search"
#set_primary_key "drug_code"
acts_as_ferret
has_many :codes
has_many :products
has_many :companies
has_one :active_ingredient
validates_numericality_of :drug_code 

  def self.full_text_search(q, options = {})
   return nil if q.nil? or q==""
   default_options = {:limit => 10, :page => 1}
   options = default_options.merge options
 
   # get the offset based on what page we're on
   options[:offset] =(options[:limit] * options.delete(:page).to_i-1)

   # now do the query with our options
   results = Drug.find_by_contents(q, options)
   return [results.total_hits, results]
  end
end


#http://216.176.50.202/formulary/SearchServlet?searchType=singleQuery&keywords=02242929