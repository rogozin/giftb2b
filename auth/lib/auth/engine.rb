module Auth
  class Engine < Rails::Engine
    config.to_prepare do
      Devise::Mailer.layout "layouts/mailers/account" # email.haml or email.erb
    end
    isolate_namespace Auth
  end
end
