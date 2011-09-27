#encoding: utf-8;
module ProductsHelper
    def product_price(product)
      price_ru_label(product.price_in_rub)
    end
    
    def price_ru_label val
      val==0 ?  "по запросу" :  number_to_currency(val, :unit => 'руб. ')
    end
    
    def product_image(product, thumb = true, title = true)
      pfi = product.main_image
      if pfi
        if thumb
          image_tag pfi.picture.url(:thumb), :alt=>product.id, :title => title ? product.short_name : nil
        else
          image_tag pfi.picture.url, :alt=>product.id, :title => title ? product.short_name : nil
        end
      else
       default_image
      end 
    end
    
    def default_image
      image_tag('default_image.jpg')
    end
    
    def article product
      if ext_user?
        raw "#{product.unique_code} <span class='article_sup'>(#{product.article})</span>"
      else
        product.unique_code
      end
    end
    
    def supplier product, use_link=true
      if ext_user? and  product.supplier
      content_tag(:p, :class => "article_name_2") do
       concat content_tag(:span, "Поставщик: ", :class => "article_t") 
       concat (use_link ? link_to(product.supplier.name, supplier_path(product.supplier.permalink)) : product.supplier.name) 
       end
      end
    end
    
    def store_count store_unit_item
      store_unit_item.option == 0 ? "по запросу" : "#{store_unit_item.count} шт."
    end
    
    def total_store_count product
       product.cached_store_units.present? && product.cached_store_units.count{ |x| x.option !=0 } > 0 ? "#{product.store_count} шт." : "по запросу"                     
    end
end
