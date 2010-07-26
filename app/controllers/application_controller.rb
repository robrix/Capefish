class ApplicationController < ActionController::Base
  cattr_accessor :default_layout_template
  @@default_layout_template ||= "default"
  cattr_accessor :site_title
  @@site_title ||= "Capefish"
  
  layout(proc do |controller|
    if controller.request.xhr? or controller.request.format == Mime::JS
      false
    elsif controller.request.format == Mime::XML
      "rss20"
    elsif controller.request.format == Mime::HTML
      @@default_layout_template
    end
  end)
  # helper :all # include all helpers, all the time
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '2d16dd9d48cacf550362ca3dad4ea6f8'
  
  protected
  
  def authenticate_capefish
    if BasicUser.has_users
      authenticate_or_request_with_http_digest do |username, password|
        if @user = BasicUser.find(username) and @user.authenticate?(password)
          session[:username] = username
        end
      end
    else
      true # no users == wiki-style (lack of) authentication
    end
  end
  
  def current_user
    @user ||= BasicUser.find(session[:username])
  end
end