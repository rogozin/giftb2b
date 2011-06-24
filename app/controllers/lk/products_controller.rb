#encoding: utf-8;
class Lk::ProductsController < Lk::BaseController
  access_control do
     allow :Администратор, "Менеджер фирмы", "Пользователь фирмы"
  end
  
  before_filter :find_lk_product, :only => [:edit, :update, :destroy]
  
  def index
    if current_user.firm_id.present?
      @products = LkProduct.active.find_all_by_firm_id(current_user.firm.id)
    else 
      @products  = []
      not_firm_assigned!
    end
  end
  
  def new
    @product = LkProduct.new({:firm_id => current_user.firm_id})
  end
  
  def create
    @product = LkProduct.new(params[:lk_product])
    if @product.save
      flash[:notice] = "Товар успешно добавлен!"
      redirect_to edit_lk_product_path(@product)
    else
      render 'new'
    end
  end
  
  def update
    if @product.update_attributes(params[:lk_product])
      flash[:notice] = "Товар изменен!"
      redirect_to (params[:redirect].present? ?  params[:redirect] :  edit_lk_product_path(@product))
    else
      render 'edit'
    end
  end
 
 def destroy
   flash[:notice] = "Товар удален!" if @product.destroy
   redirect_to lk_products_path
   
 end
 
 def find_lk_product
   @product = LkProduct.find(params[:id])
 end
 
 private :find_lk_product
 
end
