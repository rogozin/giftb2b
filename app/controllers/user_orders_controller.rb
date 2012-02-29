#encoding: utf-8;
class UserOrdersController < ApplicationController
#  layout 'lk'
  before_filter :authenticate_user!
  access_control do
     allow :simple_user
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
      @lk_order = LkOrder.new(params[:lk_order])
      @lk_order.firm_id = params.invert["Отправить заказ"].to_i
      @lk_order.attributes = {:user => current_user, :user_name => current_user.fio ? current_user.fio : current_user.username, 
                                  :user_email => current_user.email, :user_phone => current_user.phone, :is_remote => true} 
      if @lk_order.save 
        @cart = find_cart
        @cart.items.each do |cart_item|
        @lk_order.lk_order_items.create({:product => cart_item.product, :quantity => cart_item.quantity, :price => cart_item.start_price})
        @cart.items.clear
      end
      FirmMailer.new_user_order_notification(current_user,@lk_order ).deliver if @lk_order.firm && @lk_order.firm.email.present?
      UserMailer.new_order_notification(current_user, @lk_order).deliver if  current_user.active?  && current_user.email.present? 
      redirect_to complete_orders_path, :flash => {:order_id => @lk_order.id}
    else  
      redirect_to cart_index_path, :alert => "Ошибка при оформлении заказа"
    end
    #sending message to user and company
  end
  
  def complete
    @lk_order = LkOrder.find(flash[:order_id])
    render 'complete'
  end    
end
