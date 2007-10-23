class FeedController < ApplicationController
session :off

  def rss
    @posts = Post.find(:all, :order => "created_at DESC", :limit => 15)
    @feed_title = "Recent MyDrugRef Posts"
    @feed_description = "15 most recent posts in MyDrugRef"
    response.headers['Content-Type'] = 'application/rss+xml'
    render :layout => false
  end

end