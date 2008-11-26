ActionController::Routing::Routes.draw do |map|
	map.resources :pages
	
	map.root :controller => "pages", :action => "show"
	
	map.connect '*path.:format', :controller => "pages", :action => "show"
	map.connect '*path', :controller => "pages", :action => "show"
end
