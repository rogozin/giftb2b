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
      if !current_user && params[:lk_order][:user_email].blank? && params[:lk_order][:user_phone].blank?
        flash[:lk_order] = params[:lk_order]
        return redirect_to cart_index_path, :alert => "Укажите контактную информацию: email или телефон"
      end
      if params[:lk_order][:user_email] && params[:lk_order][:user_email] !~ EmailValidator.email_pattern
        flash[:lk_order] = params[:lk_order]
        return redirect_to cart_index_path, :alert => "Введите корректный email"
      end
      @lk_order = LkOrder.new(params[:lk_order])
      @lk_order.firm_id = params.invert["Отправить заказ"].to_i
      user = current_user || create_new_user(params[:lk_order])
      @lk_order.attributes = {:user => user, :user_name => user.fio ? user.fio : user.username, 
                                  :user_email => user.email, :user_phone => user.phone, :is_remote => true} 
      if @lk_order.save 
        @cart = find_cart
        @cart.items.each do |cart_item|
        @lk_order.lk_order_items.create({:product => cart_item.product, :quantity => cart_item.quantity, :price => cart_item.start_price})
      end
      @cart.items.clear
      FirmMailer.new_user_order_notification(user, @lk_order, user.active? ? user.phone : params[:lk_order][:user_phone]).deliver if @lk_order.firm && @lk_order.firm.email.present?
      UserMailer.new_order_notification(user, @lk_order).deliver if  user.active?  && user.email.present? 
      redirect_to complete_lk_user_orders_path, :flash => {:order_id => @lk_order.id}
    else  
      redirect_to cart_index_path, :alert => "Ошибка при оформлении заказа"
    end
    #sending message to user and company
  end
  
  def complete
    @lk_order = LkOrder.find(flash[:order_id])
    render 'complete', :layout => "application"
  end
  
  private
    def create_new_user opts
      #TODO отправлять пользователю информацию о регистрации
      if opts[:user_email].blank? 
        user = User.find_or_initialize_by_username("no-name")
        if user.new_record?          
          user.email = "no-name@giftb2b.ru"
          user.password = User.friendly_pass
          user.password_confirmation = user.password
          user.active = false
          user.save
          user.has_role! "Пользователь"
        end
        user
      else
        username =  opts[:user_email].split("@").first
        if username != "no-name" && User.exists?(:username => username)
          username = username + "_1"
          while User.exists?(:username => username)
            username.succ!
          end        
        end      
        user = User.new(:username => username , :email => opts[:user_email], :phone => opts[:user_phone], :password => User.friendly_pass, :active => true)
        user.password_confirmation = user.password
        AccountMailer.new_account(user, user.password).deliver if user.save    
        user.has_role! "Пользователь"
        user
      end
    end

end
