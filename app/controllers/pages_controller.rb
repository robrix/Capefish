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
		if @page = Page.find(:path => params[:path], :format => request.format)
			@page.layout_template && self.class.layout(@page.layout_template)	
		else
			error
		end
	end
	
	def edit
		@page = Page.find(:path => params[:id].split("/")) || error
		render :layout => @page.layout_template || self.class.default_layout_template
	end
	
	def update
		@page = Page.find(:path => params[:id].split("/")) || error
		File.open(Page.file_path(@page.path), "w") do |file|
			file.write params[:page_content]
		end
		render :text => "it worked"
	end
	
	def destroy
		
	end
	
	protected
	
	def error(code = 404)
		render :action => "none"
		self.class.cache_page response.body, "/404.html"
	end
end