#encoding: utf-8;
class Auth::ProfileController < ApplicationController
  before_filter :require_user
 def edit
    @account = current_user
  end
  
  def update
    @account = current_user
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end    
    if @account.update_attributes(params[:user], :as => current_user.is_firm_user? ? :default : :client)
      sign_in @account, :bypass => true if params[:user][:password].present?
      flash[:notice] = "Профиль изменен"
      #UserSession.create @account
      redirect_to profile_path
    else
      render 'edit'
    end
  end
end  
