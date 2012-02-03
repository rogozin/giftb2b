#encoding: utf-8;
class SuppliersController < BaseController
  access_control do
     allow :admin, :supplier_viewer, :lk_supplier
  end
  
  def show
    if current_user.is?(:lk_supplier)
      @supplier = current_user.firm.supplier
    else      
      @supplier = Supplier.find_by_permalink(params[:id])
    end
  end

end
