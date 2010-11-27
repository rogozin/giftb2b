class UserSessionsController < ApplicationController
 def new
    @user_session = UserSession.new
  end

  def create
    if params[:user_session][:username].blank? or params[:user_session][:username].blank?
      flash[:login_error] = "Введите имя или пароль"      
    else   
       @user_session = UserSession.new(params[:user_session])
       flash[:login_error]="Неправильное имя  или пароль" unless @user_session.save        
    end
       redirect_to root_path    
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Выход из системы успешно произведен"
    redirect_to root_path
  end
end
