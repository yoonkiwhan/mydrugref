class WarningsController < PostsController
   
  # Default action for the app; might be changed to show a dashboard-like view

  def index
    super
    @post_pages, @posts = paginate :warnings, :order_by => 'created_at desc', :per_page => 5
  end
  
   def search
    @query = params[:query]
    @total, @warnings = Warning.full_text_search(@query, :page => (params[:page]||1))        
    @pages = pages_for(@total)
    render :partial => "search", :layout => true
  end


  private
    def model_name; 'Warning'; end
    


end
