class ThreadedDiscussionPostsController < ApplicationController

  def index
    @tdpost = ThreadedDiscussionPost.new
    @page_title = "Topics"
    @posts = ThreadedDiscussionPost.find(:all, :order => "updated_at")
    @topics = Array.new
    for post in @posts
      unless post.parent_id == nil or @topics.include?(ThreadedDiscussionPost.find(post.root.id))
        @topics << ThreadedDiscussionPost.find(post.root.id)
      end
      unless post.parent_id != nil or @topics.include?(post)
        @topics << post
      end
    end
  end

  def show
    begin
      @page_title = "#{ThreadedDiscussionPost.find(params[:id]).name}"
      @tdpost = ThreadedDiscussionPost.new
      @tree = ThreadedDiscussionPost.find(params[:id]).full_set
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid forum post #{params[:id]}")
      flash[:notice] = "Forum post does not exist"
      redirect_to :action => :index
    end
  end

  def create
    @hash = params[:tdpost]
    if @hash.has_key?(:parent)
      @parent = ThreadedDiscussionPost.find(@hash[:parent])
      @hash.delete(:parent)
      puts @parent.name
    end
    @hash[:created_by] = current_user.id
    @hash[:updated_by] = current_user.id
    @tdpost = ThreadedDiscussionPost.new(@hash)
      if @tdpost.save 
        if @parent == nil
    #    @tdpost.root_id = @tdpost.id
        else
        @tdpost.move_to_child_of @parent
    #    @tdpost.root_id = @parent.root_id
        end
        @tdpost.save
        flash[:notice] = 'Post successfully created.'
        redirect_to :action => 'show', :id => @tdpost.root.id
      else
        flash[:notice] = 'Post did not save.'
      end
  end

  def edit
    @tdpost = ThreadedDiscussionPost.find(params[:id])
  end
  
  def update
      @tdpost = ThreadedDiscussionPost.find(params[:id])
      if @tdpost.update_attributes(params[:threaded_discussion_post])
          flash[:notice] = "Your changes were saved."
          redirect_to :action => 'show', :id => @tdpost.root.id        
      
      else
      render  :action => 'edit'
      end
    end

  def destroy
    @tdpost = ThreadedDiscussionPost.find_by_id(params[:id])
    @tdpost.destroy
    flash[:notice] = "The post was deleted."
    redirect_to :action => 'index'
  end

end
