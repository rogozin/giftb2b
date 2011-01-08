class Admin::SuppliersController < Admin::BaseController
  access_control do
     allow :Администратор, "Редактор каталога"
  end
  
  def index
    @suppliers = Supplier.all
  end

  def new
    @supplier = Supplier.new
  end

  def create
     @supplier = Supplier.new(params[:supplier])
     if @supplier.save
      flash[:notice] = "Новый поставщик успешно создан"
      redirect_to admin_suppliers_path
    else 
      render 'new'
     end

  end

  def edit
    @supplier= Supplier.find(params[:id])    
  end

  def update
    @supplier = Supplier.find(params[:id])
    if @supplier.update_attributes  params[:supplier]
      flash[:notice] = "Поставщик успешно изменен"
      redirect_to admin_suppliers_path
    else 
      render 'edit'  
    end
  end

def destroy
    @supplier = Supplier.find(params[:id])
    flash[:notice] = "Поставщик удален" if @supplier.destroy
    redirect_to admin_suppliers_path
  end

end

