class InteractionsController < PostsController

def index
    super
    @post_pages, @posts = paginate :interactions, :order_by => 'created_at desc', :per_page => 10
  end

def test
    @interaction = Interaction.find(params[:id])
end  
  
 def bla
    @query = params[:query]
    @total, @interactions = Interaction.full_text_search(@query, :page => (params[:page]||1))        
    @pages = pages_for(@total)
    render :partial => "bla", :layout => true
  end
 
 # controller
 auto_complete_for :interaction, :name
#  auto_complete_responder_for_warnings params[:warning][:name]
#end

def auto_complete_for_message_cc
  auto_complete_responder_for_contacts params[:message][:cc]
end
#-- 
 
  private
    def model_name; 'Interaction'; end

#--script

#def auto_complete_responder_for_warnings(value)
#  @warnings = Warning.find(:all, 
#    :conditions => [ 'LOWER(name) LIKE ?',
#    '%' + value.downcase + '%' ], 
#    :order => 'name ASC',
#    :limit => 8)
#  render :partial => 'warnings'
#end   

end
