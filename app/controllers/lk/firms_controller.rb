class Lk::FirmsController < Lk::BaseController
  access_control do
     allow :Администратор, "Менеджер фирмы", "Пользователь фирмы"
  end
  
  before_filter :find_firm, :only =>[:edit, :update, :destroy]
  
  def index
    if current_user.firm_id.present?
      @firms = LkFirm.find_all_by_firm_id(current_user.firm.id)
    else 
      @firms  = []
      flash[:error] = "Вам не назначена фирма!"
    end
  end

  def edit
  
  end

  def new
    @firm = LkFirm.new({:firm_id => current_user.firm.id})
  end

  def update
    if @firm.update_attributes(params[:lk_firm])
      flash[:notice] = "Фирма изменена!"
      redirect_to edit_lk_firm_path(@firm)
    else
      render :edit
    end
  end

  def destroy
    if @firm.destroy
      flash[:notice] = "Фирма удалена!"  
    else
      flash[:error] = "Невозможно удалить фирму! " + @firm.errors.full_messages.join(' <br />')  
    end  
    rescue => err
      flash[:error] = "Невозможно удалить фирму! " 
      flash[:error] += "Имеются коммерческие предложения!" if err.message.index('commercial_offers')
    ensure
      redirect_to lk_firms_path 
  end

  def create
    @firm = LkFirm.new(params[:lk_firm])
    if @firm.save
      flash[:notice] = "Фирма создана!"
      redirect_to lk_firms_path
    else
      render :new  
    end
  end

  private
  def find_firm
    @firm = LkFirm.find(params[:id])
  end
end
