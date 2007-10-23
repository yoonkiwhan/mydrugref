class OscarApi < ActionWebService::API::Base
  api_method :find_posts_by_atc,
             :expects => [:string],
             :returns => [[Post]]
  api_method :find_users_by_name,
             :expects => [:string],
             :returns => [[User]]
  api_method :find_post_by_id,
             :expects => [:int],
             :returns => [Post]
  api_method :get_time, :expects => [:bool], :returns => [:time]
  
end