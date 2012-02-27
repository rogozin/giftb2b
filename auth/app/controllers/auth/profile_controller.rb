#encoding: utf-8;
class Auth::ProfileController < ApplicationController
  before_filter :require_user
 def edit
    @account = current_user
  end
  
  def update
    @account = current_user
    if @account.update_attributes(params[:user], :as => current_user.is_firm_user? ? :default : :client)
      flash[:notice] = "Профиль изменен"
      #UserSession.create @account
      redirect_to profile_path
    else
      render 'edit'
    end
  end
end  
