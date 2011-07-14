#encoding: utf-8;
class Lk::AccountsController < Lk::BaseController
  access_control do
     allow :Администратор, "Менеджер фирмы"
  end
  
  def index
    if current_user.firm_id.present?
      @users = User.find_all_by_firm_id(current_user.firm_id)
    else 
      @users = []
       not_firm_assigned!
    end
  end

  def new
    @account = User.new({:firm_id => current_user.firm_id})
  end
  
  def create
    @account = User.new(params[:user])
    @account.active = true
    if @account.save
      @account.has_role! "Пользователь фирмы"
      flash[:notice] = "Пользователь успешно создан!"
      redirect_to lk_accounts_path 
    else
      flash[:alert] = "Ошибка при создании пользователя!"
      render 'new'
    end
  end

  def edit
    @account = User.find(params[:id])
  end
  
  def update
    @account = User.find(params[:id])
    if @account.update_attributes(params[:user])
      flash[:notice] = "Учетная запись изменена"
      redirect_to lk_accounts_path
    else
      render 'edit'
    end
  end
  
  def destroy
    @account = User.find(params[:id])
    flash[:notice] = "Учетная запись пользователя удалена!" if @account.destroy
    redirect_to lk_accounts_path
  end
  
  def activate
    @account = User.find(params[:id])
    @account.toggle! :active
  end
  
end
