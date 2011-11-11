module Core
  class Engine < Rails::Engine
      config.generators do |g|
      g.test_framework :rspec, :view_specs => false
    end
          
    initializer "static assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end
    config.active_record.observers = :news_observer
  end
end
