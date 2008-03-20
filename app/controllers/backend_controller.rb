require 'time'

class BackendController < ApplicationController
  web_service_api OscarApi
  web_service_scaffold :invoke

  def find_posts_by_atc(atc)
    @page_title = "did it work?"
     Post.find_all_by_atc(atc)
  end 
     
  def fetch(method, atcs, email = "")
    
  default_email = "none"
  if email == nil
  email = default_email
  end
    
  if email != "none"
  
  @user = User.find_by_email("#{email}")
  @friend_ids = Array.new
  @friend_ids << @user.id
    
    for pal in @user.friends
    @friend_ids << pal.id
    end
    
  
    if method == "interactions_byATC"
      @results = Array.new
        for atc in atcs
        @copy = Array.new(atcs)
        @copy.delete(atc)
          for code in @copy
          @array = Interaction.find(:all, :conditions => ["atc = ? and atc2 = ?", atc, code])
          @results = @results + @array
          end
        end
      @finalresults = Array.new
      for post in @results
        if @friend_ids.include?(post.created_by)
          @finalresults << post
        end
      end
      @results_ids = Array.new
      for result in @results
        @results_ids << result.id
      end
      
      @comments = Comment.find_all_by_goat(true)
      for c in @comments
        if @friend_ids.include?(c.created_by) and @results_ids.include?(c.post_id)
          @finalresults << Post.find(c.post_id)
        end
      end 
      return @finalresults
    end
    
    if method == "warnings_byATC"
      @results = Array.new
      for atc in atcs
        @array = Warning.find_all_by_atc(atc)
        @results = @results + @array
      end
      @finalresults = Array.new
      for post in @results
        if @friend_ids.include?(post.created_by)
          @finalresults << post
        end
      end
      @results_ids = Array.new
      for result in @results
        @results_ids << result.id
      end
      
      @comments = Comment.find_all_by_goat(true)
      for c in @comments
        if @friend_ids.include?(c.created_by) and @results_ids.include?(c.post_id)
          @finalresults << Post.find(c.post_id)
        end
      end 
      return @finalresults
    end
    
    if method == "bulletins_byATC"
      @results = Array.new
      for atc in atcs
        @array = Bulletin.find_all_by_atc(atc)
        @results = @results + @array
      end
      @finalresults = Array.new
      for post in @results
        if @friend_ids.include?(post.created_by)
          @finalresults << post
        end
      end
      @results_ids = Array.new
      for result in @results
        @results_ids << result.id
      end
      
      @comments = Comment.find_all_by_goat(true)
      for c in @comments
        if @friend_ids.include?(c.created_by) and @results_ids.include?(c.post_id)
          @finalresults << Post.find(c.post_id)
        end
      end 
      return @finalresults
    end     
    
    if method == "prices_byATC"
      @results = Array.new
      for atc in atcs
        @products = Product.find_all_by_atc(atc)
        for product in @products
          @prices = product.prices
          @results = @results + @prices
        end
      end
      @finalresults = Array.new
      for post in @results
        if @friend_ids.include?(post.created_by)
          @finalresults << post
        end
      end
      return @finalresults
    end
  
  elsif email == "none"
    
    if method == "interactions_byATC"
      @results = Array.new
        for atc in atcs
        @copy = Array.new(atcs)
        @copy.delete(atc)
          for code in @copy
          @array = Interaction.find(:all, :conditions => ["atc = ? and atc2 = ?", atc, code])
          @results = @results + @array
          end
        end
      return @results
    end
    
    if method == "warnings_byATC"
      @results = Array.new
      for atc in atcs
        @array = Warning.find_all_by_atc(atc)
        @results = @results + @array
      end
      return @results
    end
    
    if method == "bulletins_byATC"
      @results = Array.new
      for atc in atcs
        @array = Bulletin.find_all_by_atc(atc)
        @results = @results + @array
      end
      return @results
    end     
    
    if method == "prices_byATC"
      @results = Array.new
      for atc in atcs
        @products = Product.find_all_by_atc(atc)
        for product in @products
          @prices = product.prices
          @results = @results + @prices
        end
      end
      return @results
    end
    end
  end
  
  def narrow
    @finalresults = Array.new
      for post in @results
        if @friend_ids.include?(post.created_by)
        @finalresults << post
        end
      end 
    return @finalresults
  end
    
  def find_users_by_name(name)
    @page_title = "did it work?"
     User.find_all_by_name(name)
  end
  
  def find_post_by_id(id)
    return Post.find(id)
  end
  
  def get_time(gmt)
    (gmt)?(Time.now.getgm) : (Time.now)
  end
  
end
