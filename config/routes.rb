Rails.application.routes.draw do |map|
  resources :pages, :controller => "capefish/pages", :only => [:show, :index]
	
	root :to => "capefish/pages#show"
	
  # map.connect '*path.:format', :controller => "capefish/pages", :action => "show"
	map.connect '*path', :controller => "capefish/pages", :action => "show"
end