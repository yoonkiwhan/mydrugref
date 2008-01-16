ActionController::Routing::Routes.draw do |map|

  # A resource for each post type
  map.resources :warnings, :interactions, :treatments, :bulletins, :products, :threaded_discussion_posts, :member => { :download => :get }
  # A comments resource under every post type ex. warnings/comments
  map.resources :comments, :path_prefix => "/:post_type/:post_id"
  map.resources :prices, :path_prefix => "/:post_type/:post_id"
  
  # User and session resources
  map.resources :sessions
  map.resources :users
  

  map.connect 'cheese',
      :controller => 'posts',
      :action => 'cheese'
  map.connect 'search',
      :controller => 'warnings',
      :action => 'search'
  map.connect 'bla',
      :controller => 'interactions',
      :action => 'bla'
  map.connect 'bling',
      :controller => 'treatments',
      :action => 'bling'
  map.connect 'b_search',
      :controller => 'bulletins',
      :action => 'b_search'
  map.connect 'p_search',
      :controller => 'products',
      :action => 'p_search'
  map.connect 'remove_tag',
      :controller => 'treatments',
      :action => 'remove_tag'
  map.connect 'search_by_u',
      :controller => 'users',
      :action => 'search_by_u'
  map.connect 'best_value',
      :controller => 'products',
      :action => 'best_value'
      
  map.home 'posts/news', :controller => 'posts', :action => 'news'
  
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
   map.connect '', :controller => "posts", :action => "news"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
#  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
#  map.connect ':controller/:action/:id.:format'
#  map.connect ':controller/:action/:id'
  # Home and default routes
  map.connect ':controller/:action/:id'
end
