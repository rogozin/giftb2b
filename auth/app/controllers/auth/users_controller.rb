#encoding: utf-8;
class Auth::UsersController < ApplicationController
def new
    @can_register = params[:step] == "2"
    @user_type = giftb2b? ? "2" : "1"
    @user = User.new
  end

  def who_are_you
    if params[:i_am]=="1" 
       return giftb2b?  ? redirect_to(register_user_url(:step => 2, :host => "giftpoisk.ru")) :  redirect_to(register_user_path( :step => 2 ) )
    else
       return giftpoisk?  ? redirect_to(register_user_url(:step =>2, :host => "giftb2b.ru")) :  redirect_to(register_user_path( :step => 2 ) )
    end
      
  end

  def create    
    pass = User.friendly_pass
    @user = User.new(params[:user].merge(:active => true, :password => pass, :password_confirmation => pass))
    @user.username = @user.username_from_email
    if @user.save
      if params[:i_am] == "1"
        @firm = Firm.new(:name => @user.company_name, :city => @user.city, :url => @user.url, :phone => @user.phone, :email => @user.email, :state_id => 3)        
        unless @firm.valid?
          if @firm.errors[:name].present? 
            new_name = @firm.name + "_1"
            while Firm.exists?(:name => new_name)
              new_name.succ!
            end 
            @firm.name = new_name    
            @firm.permalink  = new_name.parameterize
            @user.company_name += " (дубликат)"
          end
        end        
        @firm.users << @user if @firm.save
        @user.has_role! "Пользователь фирмы"
      else 
        @user.has_role! "Пользователь"
      end
      UserSession.create @user
      Auth::AccountMailer.new_account(@user, pass).deliver
      notify_admins(@user)
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
      Auth::AccountMailer.activation_complete(@user).deliver
    else
      render 'activation_failed'
    end
  end
  
  def login_by_token
    @user = User.find_using_perishable_token(params[:token], 5.hours)
    if @user 
      @user.reset_persistence_token!
#      @user.reset_perishable_token!
      UserSession.create(@user)
      redirect_to main_app.root_path      
    else
      not_found
    end
  end
  
  def recovery
    
  end
  
  def change_password
    return redirect_to recovery_password_path, :alert => "Неправильный адрес Email" if EmailValidator.email_pattern !~ params[:email] || params[:email].blank?
    user = User.find_by_email(params[:email])
    return redirect_to recovery_password_path, :alert => "Пользователь с таким именем не найден!" if user.nil? || (user.present? && !user.active)
    pass = User.friendly_pass
    if user.update_attributes(:password => pass, :password_confirmation => pass)
      user_session  =  UserSession.find
      user_session.destroy if user_session
      Auth::AccountMailer.recovery_password(user, pass).deliver
      render 'password_changed'
    else
      redirect_to recovery_password_path, :alert => "Просим прощения, пароль не может быть восстановлен по некоторым причинам."
    end
    
  end
  
  private 
  def notify_admins(user)
   User.joins(:role_objects).where("active = 1 and (roles.name='Администратор' or roles.name='Менеджер продаж')").each do |admin|
     Auth::AdminMailer.new_user_registered(user, admin).deliver
   end
 end  

end
