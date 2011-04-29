class Lk::UserOrdersController < Lk::BaseController
  access_control do
     allow "Пользователь"
  end

  def index
      @orders = current_user.lk_orders.order("created_at desc")     
  end
  
  def show
    #юзер не должен увидеть чужой заказ, просто поменяв id
    @order = LkOrder.find(params[:id])
  end
  
    def create
    @order = LkOrder.new(params[:lk_order])
    @order.user = current_user
    if @order.save
      flash[:notice] = "Заказ оформлен!" 
      @cart = find_cart
      @cart.items.each do |cart_item|
        @order.lk_order_items.create({:product => cart_item.product, :quantity => cart_item.quantity, :price => cart_item.start_price})
      end
      @cart.items.clear
      UserMailer.new_order_notification(current_user, @order).deliver
      FirmMailer.new_user_order_notification(@order.firm, current_user, @order).deliver
    else  
      flash[:error] = "Заказ не удалось оформить"
    end
    #sending message to user and company
    redirect_to lk_user_orders_path
  end

end
