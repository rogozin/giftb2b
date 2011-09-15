#encoding: utf-8;
class Lk::UserOrdersController < ApplicationController
  layout 'lk'
#  access_control do
#     allow "Пользователь", :except => [:create]
#  end

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
      user = current_user || create_new_user(params[:lk_order])
      if user.valid?
        @lk_order.attributes.merge!(:user => user, :user_name => user.fio ? user.fio : user.username, 
                                  :user_email => user.email, :user_phone => user.phone, :is_remote => true) 
        if @order.save 
          @cart = find_cart
          @cart.items.each do |cart_item|
          @lk_order.lk_order_items.create({:product => cart_item.product, :quantity => cart_item.quantity, :price => cart_item.start_price})
        end
        @cart.items.clear
        # UserMailer.new_order_notification(user, @order).deliver if user.email.present?
        # FirmMailer.new_user_order_notification(user, @order).deliver if @order.firm && @order.firm.email.present?
        redirect_to lk_user_orders_path, :notice => "Заказ оформлен!"
      else  
        redirect_to cart_index_path, :alert => "Ошибка при оформлении заказа"
      end
     @lk_order.errors.add(:user_name, "Укажите имя")
     redirect_to cart_index_path, :alert => "Неверные контактные данные"
    else  
      
    end
    #sending message to user and company
  end
  
  private
    def create_new_user opts
      #TODO отправлять пользователю информацию о регистрации
      username = opts[:user_email].split("@").first
      if User.exists?(:username => username)
        username = username + "_1"
        while User.exists?(:username => username)
          username.succ!
        end        
      end
      
      user = User.new(:username => username , :email => opts[:user_email], :phone => opts[:user_phone], :password => User.friendly_pass, :active => true)
      user.password_confirmation = user.password
      user.save    
      user.has_role! "Пользователь"
      user
    end

end
