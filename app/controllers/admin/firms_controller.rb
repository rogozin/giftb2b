class Admin::FirmsController < Admin::BaseController
  access_control do
     allow :Администратор, "Менеджер продаж"
  end
  
  def index
    @firms = Firm.all
  end

  def new
    @firm = Firm.new
  end
  
  def create
    @firm = Firm.new(params[:firm])
    if @firm.save
      flash[:notice] = "Новая фирма успешно создана"      
      redirect_to admin_firms_path
    else
      render 'new'  
    end
  end

  def edit
    @firm = Firm.find(params[:id])
  end
  
  def update
    @firm = Firm.find(params[:id])
    if @firm.update_attributes(params[:firm])
      flash[:notice] = "Атрибуты фирмы изменены"
      redirect_to edit_admin_firm_path(@firm)
    else
      render 'edit'
    end
  end
  
  def destroy
    @firm = Firm.find(params[:id])
    flash[:notice] = "Фирма удалена!" if @firm.destroy
    redirect_to admin_firms_path
  end

end
