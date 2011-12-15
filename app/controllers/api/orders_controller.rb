#encoding: utf-8;
class Api::OrdersController < Api::BaseController
  
  def create
    order = LkOrder.new(:user_email => params[:order][:email], :user_comment => params[:order][:comments], :user_phone => params[:order][:phone],
    :user_name => params[:order][:name], :is_remote => true)            
    order.firm_id = @firm[:id]
    if @firm && order.save
      params[:order][:products].each do |item|
        if item.has_key?(:product)
          p = is_lk_product?(item[:product][:id]) ? find_lk_product(item[:product][:id]) : Product.find(item[:product][:id])
          order.lk_order_items << LkOrderItem.create(:product => p,:quantity => item[:product][:quantity], :price => item[:product][:price])
        elsif item.has_key?(:id) && item.has_key?(:price) && item.has_key?(:quantity)
          p = is_lk_product?(item[:id]) ? find_lk_product(item[:id]) : Product.find(item[:id])
          order.lk_order_items << LkOrderItem.create(:product => p,:quantity => item[:quantity], :price => item[:price])        
        end
        
      end 
      UserMailer.new_remote_order_notification(order).deliver
      FirmMailer.new_remote_order_notification(order).deliver
      render :json  => { :success => true }
    else
      render :json => { :success => false }
    end  
  end
  
end
