#encoding: utf-8;
class Admin::ForeignAccessController < Admin::BaseController
  access_control do
     allow :Администратор, "Менеджер продаж"
  end

  before_filter :find_firms, :only => [:new, :create, :update, :edit]
  
  def index
    @catalog_clients = ForeignAccess.all
  end

  def new
    @access_item =ForeignAccess.new
  end

  def create
      @access_item =ForeignAccess.new(params[:access_item])
      if @access_item.save
        flash[:notice] = "Запись создана"
        redirect_to admin_foreign_access_index_path
      else
        render 'new'
      end  
  end

  def edit
    @access_item= ForeignAccess.find(params[:id])    
  end

  def update
    @access_item = ForeignAccess.find(params[:id])
    if @access_item.update_attributes  params[:access_item]
      flash[:notice] = "Запись изменена"
      redirect_to admin_foreign_access_index_path
    else 
      render 'edit'  
    end
  end

  def destroy
    access_item = ForeignAccess.find(params[:id])
    access_item.destroy
    redirect_to admin_foreign_access_index_path
  end
  
  private
  
  def find_firms
    @firms = Firm.order(:short_name)
  end
  
end
