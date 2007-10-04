class PricesController < PostsController

  
def index
end


def create    
    @post = Post.find(params[:post_id])
    @price = Price.new params[:price]
    @price.post_id = @post.id
    @price.name = " Price"
    @price.creator = current_user
    @price.save
    respond_to do |format|
      format.html {
        flash[:notice] = "Price saved."
        redirect_to :back
      }
      format.js {
        render :update do |page|
          page[:prices].reload
        end
      }
    end
end

def edit
    @post = Post.find params[:post_id]
    @price = Price.find_by_id(params[:id])
  end
  
  def update
      @post = Post.find params[:post_id]
      @price = Price.find_by_id(params[:id])
      if @price.update_attributes(params[:price])
          flash[:notice] = "Your changes were saved."
          redirect_to :action => 'show', :controller => "commodities", :id => @post.id        
      
      else
      render  :action => 'edit'
      end
    end
  
  def destroy
    @post = Post.find params[:post_id]
    @price = Price.find_by_id(params[:id])
    @price.destroy
    flash[:notice] = "Price deleted."
    redirect_to :action => 'show', :controller => "commodities", :id => @post.id
  end
  
  def show
    @post = Post.find(params[:post_id])
    @price = @post.prices.find params[:id]
  end
  
end