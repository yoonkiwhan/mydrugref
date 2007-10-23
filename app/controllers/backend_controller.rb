require 'time'

class BackendController < ApplicationController
  wsdl_service_name 'Backend'
  web_service_api OscarApi
  web_service_scaffold :invoke

  def find_posts_by_atc(atc)
    @page_title = "did it work?"
     Post.find_all_by_atc(atc)
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