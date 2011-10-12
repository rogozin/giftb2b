module Lk
  class Engine < Rails::Engine
    isolate_namespace Lk

    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
    end
   initializer "static assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
      app.middleware.use ::PDFKit::Middleware
    end
  end
end
