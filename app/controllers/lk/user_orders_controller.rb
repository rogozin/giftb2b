#encoding: utf-8;
class Lk::UserOrdersController < Lk::BaseController
  access_control do
     allow "Пользователь"
  end

  def index
      @orders = current_user.lk_orders.order("created_at desc")     
  end
  
  def show
    #юзер не должен увидеть чужой заказ, просто поменяв id
    if current_user.lk_orders.exists?(params[:id])
      @order = LkOrder.find(params[:id])
    else
      not_found("Заказ не найден!")
    end
  end
  
    def create
    @order = LkOrder.new(params[:lk_order])
    @order.firm_id = params.invert["Отправить заказ"].to_i
    @order.user = current_user
    if @order.save
      flash[:notice] = "Заказ оформлен!" 
      @cart = find_cart
      @cart.items.each do |cart_item|
        @order.lk_order_items.create({:product => cart_item.product, :quantity => cart_item.quantity, :price => cart_item.start_price})
      end
      @cart.items.clear
      unless Rails.env == 'test'
        UserMailer.new_order_notification(current_user, @order).deliver if @current_user.email.present?
        FirmMailer.new_user_order_notification(@order.firm, current_user, @order).deliver if @order.firm && @order.firm.email.present?
      end
    else  
      flash[:error] = "Ошибка при оформлении заказа"
    end
    #sending message to user and company
    redirect_to lk_user_orders_path
  end

end
