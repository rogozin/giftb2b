module ProductsHelper
    def product_price(product)
      number_to_currency(product.price_in_rub, :unit => 'руб. ')
    end
    
    def product_image(product, thumb = true)
      pfi = product.images.first
      if pfi
        if thumb
          image_tag pfi.picture.url(:thumb), :alt=>product.article
        else
          image_tag pfi.picture.url, :alt=>product.article, :title=>property_name
        end
      else
       default_image
      end 
    end
    
    def default_image
      image_tag('default_image.jpg')
    end
end
