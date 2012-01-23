#encoding: utf-8;
class Admin::SuppliersController < Admin::BaseController
  access_control do
     allow :admin, :admin_catalog
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
  
  def truncate_products
    @supplier = Supplier.find(params[:id])
    res = Product.where(:supplier_id => params[:id]).each{|p| p.destroy}
    redirect_to edit_admin_supplier_path(@supplier), :notice => "Уделено #{res.size} товаров данного поставщика"
  end

end

