require 'time'

class BackendController < ApplicationController
  web_service_api OscarApi
  web_service_scaffold :invoke

  def find_posts_by_atc(atc)
    @page_title = "did it work?"
     Post.find_all_by_atc(atc)
  end
  
  def fetch(method, atcs)
    @page_title = "??"
    
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