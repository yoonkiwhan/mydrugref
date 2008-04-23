class WarningsController < PostsController
   
  # Default action for the app; might be changed to show a dashboard-like view

  def index
    super
       @sort_by = params[:sort_by]
       if @sort_by == "date"
	  @post_pages, @posts = paginate :warnings, :order_by => 'updated_at DESC', :per_page => 20
       elsif @sort_by == "author"
	  @post_pages, @posts = paginate :warnings, :order_by => 'created_by', :per_page => 20
       else
    	  @post_pages, @posts = paginate :warnings, :order_by => 'name', :per_page => 20
       end	
  end
  
   def search
    @page_title = "Search Results"
    @query = params[:query]
    @total, @warnings = Warning.full_text_search(@query, :page => (params[:page]||1))        
    @pages = pages_for(@total)
    render :partial => "search", :layout => true
  end


  private
    def model_name; 'Warning'; end
    


end
