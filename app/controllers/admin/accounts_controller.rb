#encoding: utf-8;
module Admin
class AccountsController < BaseController
  access_control do
    allow :Администратор
  end

  def index
    params[:group] ||="0"
    @users = User.joins(:role_objects).where("roles.group" => params[:group])
    if params[:group] == "1"
      render 'simple'
    else
      render 'index'
    end
  end


  def new
    @account = User.new(:password=>User.friendly_pass, :firm_id => params[:firm_id], :company_name => "admin")
    select_firms
    select_suppliers
  end

  def create
    @account = User.new(params[:admin_account])
    @account.password_confirmation = params[:admin_account][:password]    
    @account.company_name = @account.firm.name if @account.firm_id
    if @account.save
      flash[:notice] = 'Пользователь успешно создан!'
      render :show
    else 
       select_firms
       select_suppliers
      render :new
    end

  end

  def edit
    @account = User.find(params[:id])
    @roles = Role.all
    select_firms    
    select_suppliers
  end

  def update
    params[:admin_account][:role_object_ids] ||= []
    @account = User.find(params[:id])
    @account.password_confirmation = params[:admin_account][:password]
    if @account.update_attributes params[:admin_account]
      succ_updated
    else
      select_firms
      select_suppliers
      render :edit
    end
  end

  def destroy
  end

  def show
  end

  def activate
    @account = User.find(params[:id])
    @account.toggle! :active
    succ_updated 
    
  end

  private

  

  def select_firms
    @firms = Firm.all.collect{|f| [f.name, f.id]}
  end
  
  def select_suppliers
    @suppliers  = Supplier.order(:name).collect{ |s| [s.name, s.id]}
  end

  def succ_updated
    flash[:notice] = "Учетная запись обновлена!"
    if @account.firm_id
      redirect_to admin_firm_path(@account.firm_id)
    elsif @account.is_simple_user?
      redirect_to(admin_accounts_path(:group => 1))       
    else
      redirect_to(admin_accounts_path(:group=>0)) 
    end
  end

end
end
