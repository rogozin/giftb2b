#encoding: utf-8;
class Auth::UsersController < ApplicationController
def new
    @can_register = params[:step] == "2"
    @user_type = params[:i_am].presence ||  (giftb2b? ? "2" : "1")
    @user = User.new
  end

  def who_are_you
    if params[:i_am]=="1" || params[:i_am]=="3"  
       return giftb2b?  ? redirect_to(register_user_url(:step => 2, :host => "giftpoisk.ru")) :  redirect_to(register_user_path( :step => 2, :i_am => params[:i_am]) )
    else
       return giftpoisk?  ? redirect_to(register_user_url(:step =>2, :host => "giftb2b.ru")) :  redirect_to(register_user_path( :step => 2 ) )
    end
      
  end

  def create    
    params[:i_am] == "2" ?  create_single_user : create_firm_user(params[:i_am]=="3")
    if @user.persisted?
      sign_in @user
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
    
  private 
  def notify_admins(user)
    User.joins(:role_objects).where("active = 1 and (roles.name='admin' or roles.name='Главный менеджер')").each do |admin|
      Auth::AdminMailer.new_user_registered(user, admin).deliver
    end
  end 
  
  def create_firm_user(i_am_supplier = false)
    @firm = Firm.new({:name => params[:user][:company_name], :city => params[:user][:city], :url => params[:user][:url], :phone => params[:user][:phone], :email => params[:user][:email]}, :as => :register)        
    unless @firm.valid?
      if @firm.errors[:name].present? || @firm.errors[:permalink].present? 
        new_name = @firm.name + "-1"
        while Firm.exists?(:name => new_name)
          new_name.succ!
        end 
        @firm.name = new_name    
        @firm.permalink  = new_name.parameterize
      end
    end        
    if @firm.save
      pass = User.friendly_pass    
      @user = User.new(params[:user].merge( :password => pass, :password_confirmation => pass))
      @user.firm_id = @firm.id
      @user.active = true
      #@user.expire_date = Date.today.next_day(5) unless i_am_supplier
      @user.username = User.next_username(@firm.id, i_am_supplier ? "s" : "f")       
      service_codes = i_am_supplier ?  ["lk_supplier"] : ["base_ext_search", "sup_max", "co_logo", "s_cli", "my_goods"]
      if @user.save
        Service.where(:code => service_codes).each{|s| @firm.services << s}
        Auth::AccountMailer.new_account(@user, pass).deliver
      end      
    end
  end  
  
  def create_single_user
    pass = User.friendly_pass
    @user = User.new(params[:user].merge(:password => pass, :password_confirmation => pass))
    @user.username = @user.username_from_email
    @user.active = true
    if @user.save
      @user.has_role! "simple_user" 
      Auth::AccountMailer.new_account(@user, pass).deliver
    end
      
  end

end
