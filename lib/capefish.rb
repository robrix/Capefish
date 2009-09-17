# require "capefish/action_controller"

class ActionController::Routing::RouteSet
  def load_routes_with_capefish!
    capefish_routes = File.join(File.dirname(__FILE__), 
                       *%w[.. config capefish_routes.rb])
    unless configuration_files.include? capefish_routes
      add_configuration_file(capefish_routes)
    end
    load_routes_without_capefish!
  end

  alias_method_chain :load_routes!, :capefish
end