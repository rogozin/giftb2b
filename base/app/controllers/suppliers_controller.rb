#encoding: utf-8;
class SuppliersController < BaseController
  access_control do
     allow :admin, :supplier_viewer
  end
  
  def show
    @supplier = Supplier.find_by_permalink(params[:id])
  end

end
