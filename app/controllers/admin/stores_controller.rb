#encoding: utf-8;
class Admin::StoresController < Admin::BaseController
  access_control do
    allow :admin, :admin_catalog
  end
  
  before_filter :find_supplier
  before_filter :find_store, :only => [:edit, :update, :destroy]
  
  def new
    @store = @supplier.stores.new
  end
  
  def create
    @store = @supplier.stores.new(params[:store])
    if @store.save
      redirect_to edit_admin_supplier_path(@supplier), :notice => "Склад создан"
    else
      render 'new'
    end
  end
  
  
  def edit
        
  end
  
  def update
    if @store.update_attributes(params[:store])
      redirect_to edit_admin_supplier_path(@supplier), :notice => "Склад изменен"
    else
      render 'edit'
    end
  end
  
  def destroy
    flash[:notice] = "Склад удален" if @store.destroy
    respond_to do |format|
      format.html { redirect_to admin_suppliers_path(@supplier) }
      format.js {}
    end
  end
  
  private
  
  def find_store
    @store = Store.find(params[:id])
  end
  
  def find_supplier
    @supplier = Supplier.find(params[:supplier_id])
  end
  
end
