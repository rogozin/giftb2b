#encoding: utf-8;
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
  
  def cart_name
    giftpoisk? ? "Коммерческое предложение" : "Ваша корзина"
  end
  
  def cart_name_r
    giftpoisk? ? "коммерческое предложение" : "корзину"
  end
  
  def cart_name_header
    giftpoisk? ? "Ваше коммерческое предложение:" : "Ваша корзина:"
  end
  
  def big_cart_icon(full=false)
      giftpoisk? ? image_tag("kp.png") : (full ? image_tag("basket_f.png") : image_tag("basket_e.png"))
  end
  
  def add_to_cart_url(product)
    content_tag(:p, link_to(raw(add_to_cart_icon), add_cart_path(product.id), :remote => true, :method => :post, :title => "Добавить в #{cart_name_r}"), :class=> "add-to-cart")
  end
  
  private
  def add_to_cart_icon
        giftpoisk? ? "добавить в ком.предл." + image_tag("addtokp.png") : "Добавить в корзину" + image_tag("cart_add.png")     
  end

  
end
