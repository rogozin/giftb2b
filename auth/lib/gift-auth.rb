require "auth/engine"
require "controller_mix"

module Auth

end

ActionController::Base.send(:include, ControllerMix)
