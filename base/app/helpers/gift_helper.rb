#encoding: utf-8;
module GiftHelper

  def page_title(header=nil)
    default = controller_path =~ /^lk\// ? "Личный кабинет giftb2b.ru"  :  "giftb2b.ru" 
    @page_title = [header, default].compact.join(' | ')
  end

  def title(page_title, show_title = true)    
    @content_for_title = page_title.to_s
    @show_title = show_title
  end

  def show_title?
    @show_title
  end


  def local_request?
    Rails.env.development? or request.remote_ip =~ /(::1)|(127.0.0.1)|((192.168).*)/
  end
  
  def product_price(product)
    price_ru_label(product.price_in_rub)
  end
    
  def price_ru_label val
    val==0 ?  "по запросу" :  number_to_currency(val, :unit => 'руб. ')
  end
  
end
