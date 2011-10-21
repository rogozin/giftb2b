require "base/engine"
require "redcloth"
require "will_paginate"
require "base/controller_mix"

module Base
end

#ActionController::Base.send(:include, Base::ControllerMix)

ActionController::Base.instance_eval do
  include  Base::ControllerMix
  helper_method :giftpoisk?, :giftb2b?
end

