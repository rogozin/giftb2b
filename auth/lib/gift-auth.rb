require "auth/engine"
require "auth/controller_mix"
require "acl9"
require "authlogic"

module Auth

end

#ActionController::Base.send(:include, Auth::ControllerMix)

ActionController::Base.instance_eval do
  include Auth::ControllerMix
  helper_method :current_user
end

