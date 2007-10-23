class Post < ActiveRecord::Base
 acts_as_ferret
  
  has_many   :comments,  :order => 'id', :dependent => :destroy
  has_many   :prices,  :order => 'cost', :dependent => :destroy
  belongs_to :creator, :class_name => 'User', :foreign_key => "created_by"
  belongs_to :attachment, :dependent => :destroy

  validates_presence_of :name, :created_by

  def self.full_text_search(q, options = {},find_options = {})
   return nil if q.nil? or q==""
   default_options = {:limit => 10, :page => 1}
   options = default_options.merge options
  
   # get the offset based on what page we're on
   options[:offset] = options[:limit] * (options.delete(:page).to_i-1) 
  
   # now do the query with our options
   results = Warning.find_by_contents(q, options,  find_options)
   resultsb = Interaction.find_by_contents(q, options,  find_options)
   resultsc = Treatment.find_by_contents(q, options, find_options)
   resultsd = Bulletin.find_by_contents(q, options, find_options)
   puts options
   puts find_options
  
   return [results.total_hits + resultsb.total_hits + resultsc.total_hits + resultsd.total_hits, results + resultsb + resultsc + resultsd]
end
 
  # Creates an attachment from a file upload
  def file=(file)
    unless file.size == 0
      attachment=Attachment.new :content => file.read
      attachment.save
      write_attribute('attachment_id', attachment.id)
      write_attribute('attachment_filename', file.original_filename)
      write_attribute('attachment_content_type', file.content_type)
      write_attribute('attachment_size', file.size)
    end
  end
end