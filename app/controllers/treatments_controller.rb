class TreatmentsController < PostsController

  def index
    super
    @post_pages, @posts = paginate :treatments, :order_by => 'created_at desc', :per_page => 20
  end
  
  def remove_tag
    @post = Treatment.find(params[:id])
    @post.tags.delete(Tag.find(params[:which_tag]))
    if @post.save
      flash[:notice] = 'Tag has been removed.'
    end
    redirect_to :action => 'show', :id => @post  
  end
  
  def search
    @page_title = "Search Results"
    @query = params[:query]
    @total, @treatments = Treatment.full_text_search(@query, :page => (params[:page]||1))        
    @pages = pages_for(@total)
    render :partial => "bling", :layout => true
  end
  
  private
    def model_name; 'Treatment'; end
    


end
