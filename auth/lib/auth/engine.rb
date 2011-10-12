module Auth
  class Engine < Rails::Engine
    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
    end

    isolate_namespace Auth
  end
end
