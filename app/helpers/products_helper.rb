module ProductsHelper
    def product_price(product)
      number_to_currency(product.price_in_rub, :unit => 'руб. ')
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
end
