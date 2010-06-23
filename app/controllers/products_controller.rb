class ProductsController < PostsController
  
  def index
    super
    @sort_by = params[:sort_by]
       if @sort_by == "ATC"
	  @post_pages, @posts = paginate :products, :order_by => 'atc', :per_page => 20
       elsif @sort_by == "DIN"
	  @post_pages, @posts = paginate :products, :order_by => 'din', :per_page => 20
       elsif @sort_by == "manufacturer"
	  @post_pages, @posts = paginate :products, :order_by => 'news_source', :per_page => 20
       else
    	  @post_pages, @posts = paginate :products, :order_by => 'name', :per_page => 20
       end
  end

  def add_price
    Product.find_by_id(params[:id]).prices.create(params[:price])
    flash[:notice] = 'Price was successfully added'
    redirect_to :back
  end
  
  def best_value
    @page_title = "Best Value"
    #@bestprice, @cvss = Product.math_problem(params[:atc])
       if params[:cuts] == "0"
          @pieces = 1.0
       elsif params[:cuts] == "1"
          @pieces = 2.0
       elsif params[:cuts] == "2"
          @pieces = 4.0
       end
    #@pieces = params[:cuts].to_f + 1.0
    @results = Product.math_problem(params[:atc], params[:dosage], @pieces)
    render :partial => "bestvalue", :layout => true
  end
  
  def search
    @page_title = "Search Results"
    @query = params[:query]
    @total, @products = Product.full_text_search(@query, :page => (params[:page]||1))        
    @pages = pages_for(@total)
    render :partial => "search", :layout => true
  end
  
  private
    def model_name; 'Product'; end
    
end
