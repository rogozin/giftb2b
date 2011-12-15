#encoding: utf-8;
module Lk::OrdersHelper
  
  def order_source order
    order.is_remote? ? remote_order_source(order) : user_name(order.user) 
  end
  
  def remote_order_source order
    order.user ? "c сайта giftb2b.ru" : order.firm.has_foreign_access? ? "с сайта #{order.firm.foreign_access.first.name}" : "c сайта"
  end
  
  def product_supplier product
    if product.is_a?(LkProduct)
      current_user.firm.short_name
    else
      link_to product.supplier.name, main_app.supplier_path(product.supplier.permalink), :target => :blank
    end
  end
  
  
  def article_sup product
    raw "#{product.unique_code} <span class='art-sup'>(#{product.article})</span>"
  end

  
end
