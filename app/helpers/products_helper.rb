#encoding: utf-8;
module ProductsHelper
    def product_price(product)
      price_ru_label(product.price_in_rub)
    end
    
    def price_ru_label val
      val==0 ?  "по запросу" :  number_to_currency(val, :unit => 'руб. ')
    end
    
    def product_image(product, thumb = true)
      pfi = product.main_image
      if pfi
        if thumb
          image_tag pfi.picture.url(:thumb), :alt=>product.id, :title => product.short_name
        else
          image_tag pfi.picture.url, :alt=>product.id, :title => product.short_name
        end
      else
       default_image
      end 
    end
    
    def default_image
      image_tag('default_image.jpg')
    end
    
    def article product
      if current_user and (current_user.is_firm_user? or current_user.is_admin_user?)
        raw "#{product.unique_code} <span class='article_sup'>(#{product.article})</span>"
      else
        product.unique_code
      end
    end
    
    def supplier product
      content_tag(:p, content_tag(:span, "Поставщик: ", :class => "article_t") + link_to(product.supplier.name, supplier_path(product.supplier)), :class => "article_name_2") if current_user and  (current_user.is_firm_user? or current_user.is_admin_user?) and product.supplier
    end
    
    def store_count product
      product.store_count == 0 || product.store_count.blank? ? "по запросу"  : product.store_count
    end
end
