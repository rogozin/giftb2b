class Lk::OrdersController < Lk::BaseController
  access_control do
     allow :Администратор, "Менеджер фирмы", "Пользователь фирмы"
  end

  before_filter :find_order, :only => [:edit, :update, :destroy, :calculate]
  
  def index
    if (current_user.is_admin_user? || current_user.is_firm_user?) && current_user.firm_id.present? 
      @orders = LkOrder.find_all_by_firm_id(current_user.firm.id)
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
    if @order.update_attributes(params[:lk_order])
      flash[:notice] = "Заказ изменен!" 
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
    redirect_to edit_lk_order_path(@order)
  end
  
  private
  
  def find_order
    @order = LkOrder.find(params[:id])
    @lk_firms = LkFirm.find_all_by_firm_id(current_user.firm_id) if current_user.is_firm_user?
  end
end
