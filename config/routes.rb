ActionController::Routing::Routes.draw do |map|

  # A resource for each post type
  map.resources :warnings, :interactions, :treatments, :bulletins, :products, 
    :collection => { :search => :get },
    :member => { :download => :get }
  # A comments resource under every post type ex. warnings/comments
  map.resources :comments, :path_prefix => "/:post_type/:post_id"
  map.resources :prices, :path_prefix => "/:post_type/:post_id"
  
  # User and session resources
  map.resources :sessions
  map.resources :users, :collection => { :search => :get }
      
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
