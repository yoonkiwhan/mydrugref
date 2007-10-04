class CommoditiesController < PostsController
  
  def index
    super
    @post_pages, @posts = paginate :commodities, :order_by => 'name', :per_page => 20
  end

  def add_price
    Commodity.find_by_id(params[:id]).prices.create(params[:price])
    flash[:notice] = 'Price was successfully added'
    redirect_to :back
  end
  
  private
    def model_name; 'Commodity'; end
    
end
