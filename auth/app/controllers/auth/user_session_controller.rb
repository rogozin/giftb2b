#encoding: utf-8;
class Auth::UserSessionController < ApplicationController
 def new
    @user_session = UserSession.new
  end

  def create
    redirect_url = session[:return_to]
    session[:return_to] = nil
    return redirect_to(login_path, :flash => {:login_error => "Введите имя или пароль" })  if params[:user_session][:username].blank? or params[:user_session][:username].blank?
    @user_session = UserSession.new(params[:user_session])
      if @user_session.save
       user = @user_session.record 
         if user && !giftpoisk? && user.is_firm_user? && !user.is_admin?
            current_user_session.destroy
            redirect_to(login_by_token_url(:token => user.perishable_token, :host =>  "giftpoisk.ru"))
         else
          redirect_to  redirect_url.present? ? redirect_url : "/"
        end
       else
         redirect_to (redirect_url.present? ? redirect_url : "/"), :flash => {:login_error => "Неправильное имя или пароль"}
       end

  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy if @user_session
    flash[:notice] = "Выход из системы успешно произведен"
    redirect_to "/"
  end
end
