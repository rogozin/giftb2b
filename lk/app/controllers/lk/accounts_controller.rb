#encoding: utf-8;
class Lk::AccountsController < Lk::BaseController
  access_control do
     allow :Администратор, "Менеджер фирмы"
  end

  before_filter :find_account, :only => [:edit, :update, :destroy, :activate]  
  def index
    if current_user.firm_id.present?
      @users = User.where(:firm_id => current_user.firm_id)
    else 
      @users = []
       not_firm_assigned!
    end
  end

  def new
    @account = User.new({:firm_id => current_user.firm_id})
  end
  
  def create
    @password = User.friendly_pass  
    @account = User.new(params[:user].merge(:active => true, :password => @password, :password_confirmation => @password, 
                        :username => User.next_username(current_user.firm_id),
                        :city => current_user.firm.city, :company_name => current_user.firm.name ))
    if @account.save
      @account.has_role! "Пользователь фирмы"
      flash[:notice] = "Пользователь успешно создан!"
      render 'account'
    else
      flash[:alert] = "Ошибка при создании пользователя!"
      render 'new'
    end
  end

  def edit
  end
  
  def update
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
