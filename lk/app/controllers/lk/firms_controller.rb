#encoding: utf-8;
class Lk::FirmsController < Lk::BaseController
  access_control do
     allow :Администратор, "Менеджер фирмы", "Пользователь фирмы", "Интернет магазин"
#     allow "Учет образцов", :to => [:new, :create, :edit, :update]     
  end
  
  before_filter :find_firm, :only =>[:edit, :update, :destroy]
  
  def index
    if current_user.firm_id.present?
      @firms = LkFirm.where(:firm_id => current_user.firm.id)
    else 
      @firms  = []
      not_firm_assigned!
    end
  end

  def new
    @firm = LkFirm.new()
  end

  def create
    @firm = LkFirm.new(params[:lk_firm])
    @firm.firm_id = current_user.firm.id    
    if @firm.save
      flash[:notice] = "Новый клиент создан"
      redirect_to (params[:back_url].present? ? params[:back_url] : firms_path)
    else
      render :new  
    end
  end

  def edit
  
  end

  def update
    if @firm.update_attributes(params[:lk_firm])
      flash[:notice] = "Информация о клиенте изменена"
      redirect_to (params[:back_url].present? ? params[:back_url] : edit_firm_path(@firm))      
    else
      render :edit
    end
  end

  def destroy
    if @firm.destroy
      flash[:notice] = "Информация о клиенте удалена"  
    else
      flash[:alert] = "Невозможно удалить клиента! " + @firm.errors.full_messages.join(' <br />')  
    end  
    rescue => err
      flash[:alert] = "Невозможно удалить клиента! " 
      flash[:alert] += "Имеются коммерческие предложения!" if err.message.index('commercial_offers')
    ensure
      redirect_to firms_path 
  end


  private
  def find_firm
    @firm = LkFirm.where(:firm_id => current_user.firm_id).find(params[:id])
  end
end
