class ThreadedDiscussionPostsController < ApplicationController

  def index
    @tdpost = ThreadedDiscussionPost.new
    @page_title = "Topics"
    @posts = ThreadedDiscussionPost.find(:all)
    @topics = Array.new
    for post in @posts
      if post.parent_id == nil
        @topics << post
      end
    end
  end

  def show
    @page_title = "#{ThreadedDiscussionPost.find(params[:id]).name}"
    @tdpost = ThreadedDiscussionPost.new
    @tree = ThreadedDiscussionPost.find(params[:id]).full_set
  end

  def create
    @hash = params[:tdpost]
    if @hash.has_key?(:parent)
      @parent = ThreadedDiscussionPost.find(@hash[:parent])
      @hash.delete(:parent)
      puts @parent.name
    end
    @tdpost = ThreadedDiscussionPost.new(@hash)
    @tdpost.updated_by = @tdpost.created_by = current_user.id
      if @tdpost.save 
        if @parent == nil
        @tdpost.root_id = @tdpost.id
        else
        @tdpost.move_to_child_of @parent
        @tdpost.root_id = @parent.root_id
        end
        @tdpost.save
        flash[:notice] = 'Post successfully created.'
        redirect_to threaded_discussion_post_url(:id => @tdpost.root.id)
      else
        flash[:notice] = 'Post did not save.'
      end
  end

  def destroy
    @tdpost.destroy
    flash[:notice] = "The post was deleted."
    redirect_to :action => 'index'
  end

end