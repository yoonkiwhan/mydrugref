class ProductsController < PostsController
  
  def index
    super
    @post_pages, @posts = paginate :products, :order_by => 'name', :per_page => 20
  end

  def add_price
    Product.find_by_id(params[:id]).prices.create(params[:price])
    flash[:notice] = 'Price was successfully added'
    redirect_to :back
  end
  
  def p_search
    @page_title = "Search Results"
    @query = params[:query]
    @total, @products = Product.full_text_search(@query, :page => (params[:page]||1))        
    @pages = pages_for(@total)
    render :partial => "search", :layout => true
  end
  
  private
    def model_name; 'Product'; end
    
end
