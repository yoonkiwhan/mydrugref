class FeedController < ApplicationController
session :off

  def rss
    @posts = Post.find(:all, :order => "created_at DESC", :limit => 10)
    @feed_title = "Recent MyDrugRef Posts"
    @feed_description = "10 most recent posts in MyDrugRef"
    response.headers['Content-Type'] = 'application/rss+xml'
    render :layout => false
  end

end
