class Admin::ForeignAccessController < Admin::BaseController
  access_control do
     allow :Администратор, "Менеджер продаж"
  end
  
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
end
