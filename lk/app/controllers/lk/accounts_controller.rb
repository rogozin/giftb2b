#encoding: utf-8;
class Lk::AccountsController < Lk::BaseController
  access_control do
     allow :admin, :lk_admin
  end

  before_filter :find_account, :only => [:edit, :update, :destroy, :activate]  
  before_filter :check_firm
  
  def index
    @users = User.where(:firm_id => current_user.firm_id)
  end

  def new
    @account = User.new()
  end
  
  def create
    @password = User.friendly_pass  
    @account = User.new(params[:user].merge(:password => @password, :password_confirmation => @password, :company_name => current_user.firm.name ))
    @account.active = true
    @account.username = User.next_username(current_user.firm_id)
    @account.firm_id = current_user.firm_id
    @account.city = current_user.firm.city.present? ? current_user.firm.city : "Default"
    @account.role_object_ids = current_user.firm.services.map(&:role_ids).flatten.uniq if current_user.firm.services.present?
    if @account.save       
      flash[:notice] = "Пользователь успешно создан!"
      render 'account'
    else
      flash[:alert] = "Ошибка при создании нового пользователя!"
      render 'new'
    end
  end
  
  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    if @account.update_attributes(params[:user])
      flash[:notice] = "Учетная запись изменена"
      redirect_to accounts_path
    else
      render 'edit'
    end
  end
  
  def destroy
    flash[:notice] = "Учетная запись пользователя удалена!" if @account.destroy
    redirect_to accounts_path
  end
  
  def activate
    @account.toggle! :active
  end
  
  private 
  
  def find_account
    @account = User.where(:firm_id => current_user.firm_id).find(params[:id])
  end    
end
