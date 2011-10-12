#encoding: utf-8;
module Auth
  module ControllerMix

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
  
    def require_user
      unless current_user
        store_location
        flash[:alert] = "Для доступа необходимо ввести имя пользователя и пароль"
        redirect_to auth_engine.login_path
        return false
        end
    end
  
  
    def store_location
      session[:return_to] = request.fullpath
    end
  
    def ext_user?
      current_user && (current_user.is_firm_user? || current_user.is_admin?) 
    end

  end
end
