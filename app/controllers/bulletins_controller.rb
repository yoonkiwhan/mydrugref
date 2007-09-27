class BulletinsController < PostsController

def index
    super
    @post_pages, @posts = paginate :bulletins, :order_by => 'created_at desc', :per_page => 5
end

def b_search
    @page_title = "Search Results"
    @query = params[:query]
    @total, @bulletins = Bulletin.full_text_search(@query, :page => (params[:page]||1))        
    @pages = pages_for(@total)
    render :partial => "search", :layout => true
  end

  private
    def model_name; 'Bulletin'; end
    
end
