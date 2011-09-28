#encoding: utf-8;
class UsersController < ApplicationController
def new
    @can_register = flash[:can_register] || false
    @user = User.new
  end

  def create
    return redirect_to(register_user_path, :flash => {:can_register => true}) if params[:step].blank? ||  params[:step] == "step_1"       
    @user = User.new(params[:user])
    if @user.save
      AccountMailer.activation_email(@user).deliver
      @user.has_role! "Пользователь"
      flash[:notice] = "Учетная запись создана."
      render 'thanks'
    else
      @can_register = true
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
    @user = User.find_using_perishable_token(params[:activation_code], 48.hours)
    if @user && @user.update_attribute(:active, true)
      flash[:notice] = "Учетная запись активирована"
      AccountMailer.activation_complete(@user).deliver
    else
      render 'activation_failed'
    end
  end

end
