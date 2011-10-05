#encoding: utf-8;
class ProfileController < ApplicationController
  before_filter :require_user
  layout "lk"
 def edit
    @account = current_user
  end
  
  def update
    @account = current_user
    if @account.update_attributes(params[:user])
      flash[:notice] = "Профиль изменен"
      UserSession.create @account
      redirect_to profile_path
    else
      render 'edit'
    end
  end
end  
