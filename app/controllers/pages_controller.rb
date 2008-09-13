class PagesController < ApplicationController
	def index
		@pages = Page.roots
		respond_to do |format|
			format.html
			format.xml
		end
	end
	
	def new
		@page = Page.new(:format => Mime::HTML)
		render :action => "edit", :layout => false
	end
	
	def create
		
	end
	
	def show
		@page = Page.find(:path => params[:path], :format => request.format) || error
	end
	
	def edit
		@page = Page.find(:path => params[:path], :format => request.format) || error
	end
	
	def update
		
	end
	
	def destroy
		
	end
	
	protected
	
	def error(code = 404)
		render :action => "none"
		self.class.cache_page response.body, "/404.html"
	end
end