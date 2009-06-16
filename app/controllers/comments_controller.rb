class CommentsController < ApplicationController

  before_filter :find_post
  

  def index
  end

    def find_post
      @post = Post.find params[:post_id]
     
    end
  # Handles both Ajax and regular form submissions
  def create
    
    @comment = Comment.new params[:comment]
    @comment.post_id = @post.id
    @comment.name = "Re: #{@post.name}"
    @comment.creator = current_user
    @comment.save
    respond_to do |format|
      format.html {
        flash[:notice] = "Comment saved."
        redirect_to :back
      }
      format.js {
        render :update do |page|
          page[:comments].reload
        end
      }
    end
  end
  
  def edit
    @comment = Comment.find(params[:id])
  end
  
  def update
      @comment = Comment.find(params[:id])
      
      if @comment.update_attributes(params[:comment])
          flash[:notice] = "Your changes were saved."
          redirect_to :action => 'show', :controller => "#{@post.class.to_s}s", :id => @comment.post_id        
      
      else
      render  :action => 'edit'
      end
    end
  
  def destroy
    @comment = Comment.find_by_id(params[:id])
    @comment.destroy
    flash[:notice] = "The comment was deleted."
    redirect_to :action => 'show', :controller => "#{@post.type}s", :id => @post.id
  end
  
  def show
    @comment = @post.comments.find params[:id]
    
  end
  
end