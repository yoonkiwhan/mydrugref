class TreatmentsController < PostsController

  def index
    super
    @post_pages, @posts = paginate :treatments, :order_by => 'created_at desc', :per_page => 5
  end

  def add_tag
    @treat = Treatment.find(params[:id])
    # changed to reflect latest version of acts_as_taggable_on_steroids
    @treat.tag_list.add("Psychiatry and Behaviour")
    if @treat.save
      flash[:notice] = 'Tag has been added.'
    end
    redirect_to :action => 'show', :id => @treat
  end
  
  def remove_tag
    @post = Treatment.find(params[:id])
    @post.tags.delete(Tag.find(params[:which_tag]))
    if @post.save
      flash[:notice] = 'Tag has been removed.'
    end
    redirect_to :action => 'show', :id => @post  
  end
  
  private
    def model_name; 'Treatment'; end
    


end
