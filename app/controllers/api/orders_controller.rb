#encoding: utf-8;
class Api::OrdersController < Api::BaseController
  
  def create
    order = LkOrder.new(:user_email => params[:order][:email], :user_comment => params[:order][:comments], :user_phone => params[:order][:phone],
    :user_name => params[:order][:name], :firm_id => @firm[:id])            
    if @firm && order.save
      params[:order][:products].each do |item|
        p = Product.find(item[:product][:id])
        order.lk_order_items << LkOrderItem.create(:product => p,:quantity => item[:product][:quantity], :price => item[:product][:price])
      end    
      render :json  => { :success => true }
    else
      render :json => { :success => false }
    end  
  end
  
end
