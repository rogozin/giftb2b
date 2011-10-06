#encoding: utf-8;
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
      redirect_to "/login"
      return false
    end
  end
  
  
  def store_location
    session[:return_to] = request.fullpath
  end

end
