#encoding: utf-8;
module Lk::OrdersHelper
  
  def order_source order
    order.is_remote? ? remote_order_source(order) : user_name(order.user) 
  end
  
  def remote_order_source order
    order.user ? "c сайта giftb2b.ru" : order.firm.has_foreign_access? ? "с сайта #{order.firm.foreign_access.first.name}" : "c сайта"
  end
  
end
