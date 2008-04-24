require 'time'

class BackendController < ApplicationController
  web_service_api OscarApi
  web_service_scaffold :invoke

  def find_posts_by_atc(atc)
    @page_title = "did it work?"
     Post.find_all_by_atc(atc)
  end 

  def thumbs_up_from_friend(resultpost, friends)
     for comment in resultpost.comments
        if friends.include?(comment.creator) and comment.goat == true
           return true
        end
     end
     return false
  end

  def convert_to_o_r(post)
     
     ocult = Oscarresult.new(:id => post.id, :created_at => post.created_at, :updated_at => post.updated_at, 
                             :created_by => post.created_by, :updated_by => post.updated_by, :body => post.body, 
                             :name => post.name, :atc => post.atc, :drug2 => post.drug2, :atc2 => post.atc2, 
                             :effect => post.effect, :evidence => post.evidence, :reference => post.reference, 
                             :significance => post.significance, :news_source => post.news_source, 
                             :news_date => post.news_date, :trusted => post.trusted, :type => post.class, 
                             :author => post.creator.name, :comments => convert_to_o_com(post.comments))
  end

  def convert_to_o_com(comray)
     omray = []    
        for com in comray
           ocom = Oscarcom.new(:id => com.id, :created_at => com.created_at, :updated_at => com.updated_at, :created_by => com.created_by, :updated_by => com.updated_by, :body => com.body, :name => com.name, :post_id => com.post_id, :goat => com.goat, :author => com.creator.name)
           omray << ocom  
        end   
     omray
  end

  def trust_sort(results, buds, inclu)
     
     fresults = Array.new
     for post in results
        if buds.include?(post.creator) or thumbs_up_from_friend(post, buds) == true
           if inclu == true
             post[:trusted] = (true)
           elsif inclu == false
             fresults << post
           end
        end
        if inclu == true
           fresults << post
        end
      end
   return fresults
  end

     
  def fetch(methods, atcs, email = "", inclusive = true)
    
  default_email = "none"
  if email == nil
  email = default_email
  end

  if inclusive == nil
  inclusive = true
  end
    
     if email != "none"
  
     @user = User.find_by_email("#{email}")
  
        if @user == nil
        email = "none"

        else

           @friends_n_me = @user.friends
           @friends_n_me << @user
    
         end     

      end 

methodarray = []
methods.each(',') {|m| methodarray << m}
methodarray.each {|meth| meth.delete!(",")}
methodarray.each {|meth| meth.strip!}

@final_final_array = []

for method in methodarray
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

          @oscarresults = []
 
          for post in @results
             @osc = convert_to_o_r(post)
             @oscarresults << @osc
          end
       
       else

      @finalresults = trust_sort(@results, @friends_n_me, inclusive)

      @oscarresults = []
 
          for post in @finalresults
             @osc = convert_to_o_r(post)
             @oscarresults << @osc
          end
    
      end

    end
    

    if method == "warnings_byATC"
      @results = Array.new
      for atc in atcs
        @array = Warning.find_all_by_atc(atc)
        @results = @results + @array
      end

       if email == "none"
          
          @oscarresults = []
 
          for post in @results
             @osc = convert_to_o_r(post)
             @oscarresults << @osc
          end
 
       else

      @finalresults = trust_sort(@results, @friends_n_me, inclusive)

      @oscarresults = []
 
          for post in @finalresults
             @osc = convert_to_o_r(post)
             @oscarresults << @osc
          end
    
      end

    end

    if method == "bulletins_byATC"
      @results = Array.new
      for atc in atcs
        @array = Bulletin.find_all_by_atc(atc)
        @results = @results + @array
      end

      if email == "none"

         @oscarresults = []
 
          for post in @results
             @osc = convert_to_o_r(post)
             @oscarresults << @osc
          end

      else

      @finalresults = trust_sort(@results, @friends_n_me, inclusive)

      @oscarresults = []
 
          for post in @finalresults
             @osc = convert_to_o_r(post)
             @oscarresults << @osc
          end
    
      end

    end

  @final_final_array = @final_final_array + @oscarresults

end

return @final_final_array
 
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
