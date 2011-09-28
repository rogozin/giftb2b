#encoding: utf-8;
class UsersController < ApplicationController
def new
    @can_register = flash[:can_register] || false
    @user_type = flash[:user_type]
    @user = User.new
  end

  def create    
    return redirect_to(register_user_path, :flash => {:can_register => true, :user_type => params["i_am"]}) if params[:step].blank? ||  params[:step] == "step_1"       
    pass = User.friendly_pass
    @user = User.new(params[:user].merge(:active => true, :password => pass, :password_confirmation => pass))
    @user.username = @user.username_from_email
    if @user.save
      if params[:i_am] == "1"
        @firm = Firm.create(:name => @user.company_name, :city => @user.city)        
        @firm.users << @user
        @user.has_role! "Пользователь фирмы"
      else 
        @user.has_role! "Пользователь"
      end
      AccountMailer.new_account(@user, pass).deliver
      render 'thanks'
    else
      @user_type = params["i_am"]
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
