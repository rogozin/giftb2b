require "lk/engine"
require 'pdfkit'
require 'writeexcel'
require 'will_paginate'
require "composite_primary_keys"
require "paperclip"
require "magic_routes"
require "remotipart"
require "bootstrap-rails"
module Lk
end

 Rails::Engine.send(:include, Magic::Rails::Engine)
