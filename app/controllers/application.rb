# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
	cattr_accessor :default_layout_template
	@@default_layout_template = "default"
	cattr_accessor :site_title
	@@site_title = "Capefish"
	
	layout(proc do |controller|
		if controller.request.xhr? or controller.request.format == Mime::JS
			false
		elsif controller.request.format == Mime::XML
			"rss20"
		else
			@@default_layout_template
		end
	end)
	helper :all # include all helpers, all the time
	# before_filter :flickr
	
	# See ActionController::RequestForgeryProtection for details
	# Uncomment the :secret if you're not using the cookie session store
	protect_from_forgery # :secret => '2d16dd9d48cacf550362ca3dad4ea6f8'
	
	def default_url_options(options)
		{ :only_path => true }
	end
	
	protected
	
	def reporting_errors_on(*objs)
		valid = objs.all?{ |obj| obj.valid? }
		render :update do |page|
			if valid
				yield page
			else
				flash[:error] = objs.map{ |obj| obj.errors.full_messages }.flatten.join($/)
				page.alert flash[:error]
			end
		end
		return valid
	end
	
	def current_user
		#User.find session[:user_id]
		@user
	end
end