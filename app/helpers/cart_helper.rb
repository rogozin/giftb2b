module CartHelper
   def my_cart
    session[:cart]
   end
   
  def cart_items
    cnt  =  session[:cart]  ? session[:cart].total_items : 0 
    cnt.to_s + " " + Russian.p(cnt, "товара", "товара", "товаров")
  end
  
  def full_cart?
    my_cart and my_cart.total_items >0
  end
end
