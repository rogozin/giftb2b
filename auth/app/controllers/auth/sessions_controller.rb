class Auth::SessionsController < Devise::SessionsController


private

    def after_sign_in_path_for(resource_or_scope)
      stored_location_for(resource_or_scope) || main_app.root_path
    end

    def after_sign_out_path_for(resource_or_scope)
      stored_location_for(resource_or_scope) || main_app.root_path
    end  
  
end
