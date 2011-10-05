#require 'pdfkit'
module Lk
  class Engine < Rails::Engine
    isolate_namespace Lk

    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
    end
      #middleware.use ::PDFKit::Middleware
  end
end
