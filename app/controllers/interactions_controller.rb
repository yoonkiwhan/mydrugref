class InteractionsController < PostsController

  def index
    super
    @post_pages, @posts = paginate :interactions, :order_by => 'name', :per_page => 25
  end
  
  def allnewindex
    super
    @post_pages, @posts = paginate :interactions, :order_by => '#{order}', :per_page => 25
  end  

  def test
    @interaction = Interaction.find(params[:id])
  end  
  
  def bla
    @page_title = "Search Results"
    @query = params[:query]
    @total, @interactions = Interaction.full_text_search(@query, :page => (params[:page]||1))        
    @pages = pages_for(@total)
    render :partial => "bla", :layout => true
  end

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
