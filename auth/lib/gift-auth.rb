require "auth/engine"
require "auth/controller_mix"
require "auth/devise_mix"
require "devise"
require "auth/devise"
require "acl9"

module Auth

end


ActionController::Base.instance_eval do
  include Auth::ControllerMix
  helper_method :current_user
  helper_method :ext_user?
end

