#encoding: utf-8;
class Lk::OrdersController < Lk::BaseController
  access_control do
     allow :Администратор, "Менеджер фирмы", "Пользователь фирмы"
  end

  before_filter :find_order, :only => [:edit, :update, :destroy, :calculate, :add_product]
  
  def index
    if (current_user.is_admin_user? || current_user.is_firm_user?) && current_user.firm_id.present? 
      @orders = LkOrder.where(:firm_id => current_user.firm.id).order("id desc")
    else 
      @orders  = []
      not_firm_assigned!
    end
  end

  def create
    @order = LkOrder.new(params[:lk_order])
    @order.firm = current_user.firm
    @order.user = current_user
    flash[:notice] = "Заказ оформлен!" if @order.save
    @cart = find_cart
    @cart.items.each do |cart_item|
      @order.lk_order_items.create({:product => cart_item.product, :quantity => cart_item.quantity, :price => cart_item.start_price})
    end
    @cart.items.clear
    redirect_to lk_orders_path
  end
   
  def update
    current_status = @order.status_id
    if @order.update_attributes(params[:lk_order])
      flash[:notice] = "Заказ изменен!" 
      UserMailer.update_order_notification(@order).deliver if params[:lk_order][:status_id].to_i != current_status
      redirect_to edit_lk_order_path(@order)
    else
      render 'edit'
    end    
  end
   
  def calculate
    params[:price].each do |key, value|
      lkoi = LkOrderItem.find(key)
      lkoi.price = value
      lkoi.quantity = params[:quantity][key] if params[:quantity].has_key?(key)
      lkoi.quantity == 0 ? lkoi.destroy : lkoi.save
    end
    redirect_to edit_lk_order_path(@order), :notice => "Заказ изменен"
  end
  
  def destroy
    flash[:notice] = "Заказ удален" if @order.destroy
    redirect_to lk_orders_path
  end
  
  def add_product
     cnt = 0
     params[:lk_product_ids] ||=[]
     params[:cart_product_ids] ||=[]
     params[:lk_product_ids].each  do |lk_product_id|
       lk_product = LkProduct.find(lk_product_id)
      cnt +=1 if @order.lk_order_items.create({:quantity => 1, :product => lk_product, :price => lk_product.price })
     end
     params[:cart_product_ids].each do |cart_product_id|
       product = Product.find(cart_product_id)
      cnt +=1 if  @order.lk_order_items.create({:product=>product, :quantity => 1, :price => product.price_in_rub })
    end
    
    if cnt > 0
      flash[:notice] =  I18n.t(:lk_order_added_products, :count => cnt)
    else
      flash[:alert] =  I18n.t(:lk_order_added_products, :count => 0)
    end
    
     redirect_to edit_lk_order_path(@order)
  end
   

  private
  
  def find_order
    @order = LkOrder.find(params[:id])
    @lk_firms = LkFirm.where(:firm_id => current_user.firm_id) if current_user.is_firm_user?
  end
end
