#encoding: utf-8;
class Admin::FirmsController < Admin::BaseController
  access_control do
     allow :admin, :admin_users
  end
  
  before_filter :find_services
  
  def index
    @firms = Firm.all
  end

  def show
    @firm = Firm.find(params[:id])
  end

  def new
    @firm = Firm.new
  end
  
  def create
    @firm = Firm.new(params[:firm])
    if @firm.save
      flash[:notice] = "Новая фирма успешно создана"      
      redirect_to (params[:back_url].present? ? params[:back_url] : edit_admin_firm_path(@firm))
    else
      render 'new'  
    end
  end

  def edit
    @firm = Firm.find(params[:id])
  end
  
  def update
    @firm = Firm.find(params[:id])
    new_service_ids = (params[:firm].delete(:service_ids) || []).map(&:to_i) 
    old_service_ids = @firm.service_ids
    if @firm.update_attributes(params[:firm])      
      @firm.firm_services.active.where(:service_id => (old_service_ids-new_service_ids)).each{|s| s.destroy}
      @firm.service_ids += new_service_ids-old_service_ids
      flash[:notice] = "Атрибуты фирмы изменены"
      redirect_to  (params[:back_url].present? ? params[:back_url] : edit_admin_firm_path(@firm))
    else
      render 'edit'
    end
  end
  
  def destroy
    @firm = Firm.find(params[:id])
    if @firm.destroy
      flash[:notice] = "Фирма удалена!" 
      ActiveRecord::Base.connection.execute "update clients set firm_id = null where firm_id = #{@firm.id}"
    end
    redirect_to admin_firms_path
  end
  
  def add_image
    @firm = Firm.find(params[:id])
    @firm.images.delete_all
    flash[:notice] = "Логотип изменен" if AttachImage.create(:attachable => @firm, :image => Image.create(params[:image]))
    redirect_to edit_admin_firm_path(@firm)
  end
  
  def remove_image
     @firm = Firm.find(params[:id])   
     @firm.images.delete_all
     redirect_to edit_admin_firm_path(@category), :notice => "Логотип удален"
  end
  
  private 
  
  def find_services
    @services = Service.order("type_id, name")
  end

end
