#encoding: utf-8;
class Auth::UserSessionController < ApplicationController
 def new
    @user_session = UserSession.new
  end

  def create
    return redirect_to(login_path, :flash => {:alert=> "Введите имя или пароль",  :login_error => "Введите имя или пароль" })  if params[:user_session][:username].blank? or params[:user_session][:username].blank?
    @user_session = UserSession.new(params[:user_session])
      if @user_session.save
        @user = @user_session.record 
        if @user.password_salt.blank?
          @user.password = params[:user_session][:password] 
          @user.save(:validate => false)
        end
        return redirect_to_giftpoisk if @user && giftb2b? && @user.is_firm_user? && !@user.is_admin_user?
        return redirect_to_giftb2b if @user && giftpoisk? && @user.is_simple_user?
        redirect_to  session[:return_to].presence || request.referer.presence || "/"
       else         
         redirect_to login_path, :flash => {:alert => @user_session.errors.full_messages.join(', ')}
       end

  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy if @user_session
    session[:return_to]=nil
    flash[:notice] = "Выход из системы успешно произведен"
    redirect_to "/"
  end
  
  private
  
  def redirect_to_giftpoisk
      current_user_session.destroy
      redirect_to(login_by_token_url(:token => @user.perishable_token, :host =>  "giftpoisk.ru"))
  end
  
  def redirect_to_giftb2b
      current_user_session.destroy
      redirect_to(login_by_token_url(:token => @user.perishable_token, :host =>  "giftb2b.ru"))    
  end
  
end
