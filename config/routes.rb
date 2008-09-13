ActionController::Routing::Routes.draw do |map|
	map.login 'login', :controller => "sessions", :action => "new"
	map.create_session 'sessions/create', :controller => "sessions", :action => "create"
	map.logout 'logout', :controller => "sessions", :action => "destroy"
	
	map.resources :users
	map.resources :pages
	map.resources :tags
	
	map.resources :galleries do |galleries|
		galleries.resources :photos
	end
	
	map.connect 'tags/*path', :controller => "tags", :action => "show"
	
	map.main '', :controller => "pages", :action => "show" # shows the first page, i.e. the one with the lowest id
	
	map.connect '*path.:format', :controller => "pages", :action => "show"
	map.connect '*path', :controller => "pages", :action => "show"
end
