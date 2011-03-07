class UsersController < ApplicationController
def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.activation_email(@user).deliver
      @user.has_role! "Пользователь"
      flash[:notice] = "Учетная запись создана."
      render 'thanks'
    else
      render 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Профиль пользователя  успешно изменен."
      redirect_to :root
    else
      render :action => 'edit'
    end
  end
  
  def activate
    @user = User.find_using_perishable_token(params[:activation_code], 1.hour)
    if @user && @user.update_attribute(:active, true)
      flash[:notice] = "Учетная запись активирована"
      UserMailer.activation_complete(@user).deliver
    else
      render 'activation_failed'
    end
  end

end
