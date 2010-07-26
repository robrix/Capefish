module Capefish
  require "cgi"

  class PagesController < ApplicationController
  	before_filter :authenticate_capefish, :except => [:show, :index]
	
  	def index
  		@pages = Page.roots
  		respond_to do |format|
  			format.html { authenticate }
  			format.xml
  		end
  	end
	
    # def new
    #     
    # end
    #   
    # def create
    #     
    # end
	
  	def show
  		path = params[:path]
  		@page = Page.find(:path => path)
  		if @page
    		respond_to do |format|
    			format.html do
    				@page.layout_template && self.class.layout(@page.layout_template)
    			end
    			format.xml do
    				@pages = @page.children
    				render :action => "index"
    			end
    		end
  		else
  		  error
  		end
  	end
	
    # def edit
    #   @page = Page.find(:path => CGI::unescape(params[:id]).split("/")) || error
    #   render :layout => @page.layout_template || self.class.default_layout_template
    # end
    #   
    # def update
    #   @page = Page.find(:path => CGI::unescape(params[:id]).split("/")) || error
    #   File.open(Page.file_path(@page.path), "w") do |file|
    #     file.write params[:page_content]
    #   end
    #   render :text => "it worked"
    # end
    #   
    # def destroy
    #     
    # end
	
  	protected
	
  	def error(code = 404)
  		render :action => "none.html.erb", :status => code, :content_type => "text/html"
  		self.class.cache_page response.body, "/#{code}.html"
  	end
  end
end
