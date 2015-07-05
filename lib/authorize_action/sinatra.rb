module AuthorizeAction
  module Sinatra
    include AuthorizeAction

    def self.included(base)
      AuthorizeAction.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def action(request_method, request_path)
        request_method = request_method.to_s.upcase
        *_, route = routes[request_method].find {|pattern, _| request_path.match(pattern) }
        route && route.instance_variable_get(:@route_name) && route.instance_variable_get(:@route_name).to_sym || "#{request_method} #{request_path}".to_sym
      end
    end

    private

    def forbid_action!
      halt(403)
    end

    def current_action_name
      self.class.action(request.request_method, request.path_info)
    end
  end
end

