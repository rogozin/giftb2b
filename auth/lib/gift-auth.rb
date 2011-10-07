require "auth/engine"
require "controller_mix"
require "acl9"
require "authlogic"

module Auth

end

ActionController::Base.send(:include, ControllerMix)
