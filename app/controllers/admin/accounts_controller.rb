module Admin
class AccountsController < BaseController
  access_control do
    allow :Администратор
  end
  def index
    @users = User.find(:all)
  end

  def new
    @account = User.new(:password=>friendly_pass)
    select_firms
    select_suppliers
  end

  def create
    @account = User.new(params[:admin_account])
    @account.password_confirmation = params[:admin_account][:password]
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
    @admin_user = User.find(params[:id])
    succ_updated if @admin_user.update_attribute :active, !@admin_user.active?
  end

  private

  def friendly_pass
      fr_chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
        newpass = ""
        1.upto(6) { |i| newpass << fr_chars[rand(fr_chars.size-1)] }
        newpass
   end

  def select_firms
    @firms = Firm.all.collect{|f| [f.name, f.id]}
  end
  
  def select_suppliers
    @suppliers  = Supplier.order(:name).collect{ |s| [s.name, s.id]}
  end

  def succ_updated
    flash[:notice] = "Учетная запись обновлена!"
    redirect_to admin_accounts_path
  end

end
end
