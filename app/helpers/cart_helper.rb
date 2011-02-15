module CartHelper
   def my_cart
    session[:cart]
   end
   
  def cart_items
    I18n.t(:product, :count => session[:cart]  ? session[:cart].total_items : 0 )
  end
  
  def full_cart?
    my_cart and my_cart.total_items >0
  end
end
