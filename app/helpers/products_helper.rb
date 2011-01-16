module ProductsHelper
    def product_price(product)
      price_ru_label(product.price_in_rub)
    end
    
    def price_ru_label val
      number_to_currency(val, :unit => 'руб. ')
    end
    
    def product_image(product, thumb = true)
      main_attachable_image = product.attach_images.find_by_main_img(true)
      pfi =  main_attachable_image ? main_attachable_image.image : product.images.first
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
        "#{product.unique_code} (#{product.article})"
      else
        product.unique_code
      end
    end
    
    def supplier product
      content_tag(:p, content_tag(:span, "Поставщик: ", :class => "article_t") + product.supplier.name, :class => "article_name_2") if current_user and  (current_user.is_firm_user? or current_user.is_admin_user?) and product.supplier
    end
end
