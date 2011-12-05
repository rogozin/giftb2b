#encoding: utf-8;
module GiftHelper

  def page_title(header=nil)
    default = controller_path =~ /^lk\// ? "Личный кабинет giftpoisk.ru"  :  ActionMailer::Base.default_url_options[:host] 
    @page_title = [header, default].compact.join(' | ')
  end

  def title(page_title, show_title = true)    
    @page_title = page_title.to_s
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
  
  
  def load_search_data
   if ext_user? || giftpoisk?
      @categories = Category.cached_catalog_categories
      @thematic  = Category.cached_thematic_categories
      @analogs  = Category.cached_analog_categories
      @suppliers = Supplier.order("name")
      @manufactors =  Manufactor.cached_active_manufactors
      @infliction = Property.where(:name => "Нанесение").first      
      @material = Property.where(:name => "Материал").first            
    end
    @color = Property.where(:name => "Цвет").first             
  end
  
end
