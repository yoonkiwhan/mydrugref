require 'time'

class BackendController < ApplicationController
  web_service_api OscarApi
  web_service_scaffold :invoke

  def find_posts_by_atc(atc)
    @page_title = "did it work?"
     Post.find_all_by_atc(atc)
  end 
     
  def fetch(method, atcs, email = "", inclusive = true)
    
  default_email = "none"
  if email == nil
  email = default_email
  end
    
     if email != "none"
  
     @user = User.find_by_email("#{email}")
  
        if @user == nil
        email = "none"

        else

           @friend_ids = Array.new
           @friend_ids << @user.id
    
           for pal in @user.friends
              @friend_ids << pal.id
           end
    
         end     

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

       if email == "none"
          return @results
       
       else

      @finalresults = Array.new

      for post in @results
        if @friend_ids.include?(post.created_by)
           if inclusive == true
             post.attributes["trusted"] = true
           elsif inclusive == false
             @finalresults << post
           end
        end
        if inclusive == true
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
          @post = Post.find(c.post_id)
          if inclusive == true
             @post.attributes["trusted"] = true
          elsif inclusive == false   
             @finalresults << @post
          end
        end
        if inclusive == true
           @finalresults << post
        end
      end 
      return @finalresults
    
      end

    end
    

    if method == "warnings_byATC"
      @results = Array.new
      for atc in atcs
        @array = Warning.find_all_by_atc(atc)
        @results = @results + @array
      end
 
       if email == "none"
          return @results
 
       else

      @finalresults = Array.new
      for post in @results
        if @friend_ids.include?(post.created_by)
           if inclusive == true
             post.attributes["trusted"] = true
           elsif inclusive == false
             @finalresults << post
           end
        end
        if inclusive == true
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
          @post = Post.find(c.post_id)
          if inclusive == true
             @post.attributes["trusted"] = true
          elsif inclusive == false   
             @finalresults << @post
          end
        end
        if inclusive == true
           @finalresults << post
        end
      end 
      return @finalresults
    
      end

    end

    if method == "bulletins_byATC"
      @results = Array.new
      for atc in atcs
        @array = Bulletin.find_all_by_atc(atc)
        @results = @results + @array
      end

      if email == "none"
         return @results

      else

      @finalresults = Array.new
      for post in @results
        if @friend_ids.include?(post.created_by)
           if inclusive == true
             post.attributes["trusted"] = true
           elsif inclusive == false
             @finalresults << post
           end
        end
        if inclusive == true
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
          @post = Post.find(c.post_id)
          if inclusive == true
             @post.attributes["trusted"] = true
          elsif inclusive == false   
             @finalresults << @post
          end
        end
        if inclusive == true
           @finalresults << post
        end
      end 
      return @finalresults
    
      end

    end

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

      if email == "none"
         return @results

      else

      @finalresults = Array.new
      for post in @results
        if @friend_ids.include?(post.created_by)
	   if inclusive == true
              post.attributes["trusted"] = true
           elsif inclusive == false
             @finalresults << post
           end
        end
        if inclusive == true
           @finalresults << post
        end
      end
      return @finalresults

      end

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
