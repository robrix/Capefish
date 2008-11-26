ActionController::Routing::Routes.draw do |map|
	map.resources :pages
	
	map.main '', :controller => "pages", :action => "show" # shows the first page, i.e. the one with the lowest id
	
	map.connect '*path.:format', :controller => "pages", :action => "show"
	map.connect '*path', :controller => "pages", :action => "show"
end
