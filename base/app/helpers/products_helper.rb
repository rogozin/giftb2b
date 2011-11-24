#encoding: utf-8;
module ProductsHelper
 
    
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
    
    
    def units_count store_units, opt
      opts = opt ==1 ? [-1,0,1] : [opt]      
      opt_units = store_units.select{|x| opts.include?(x.option)}
      opt_units.present? ? store_count_value(opt_units.first) : ""
    end
    
    def store_count_value store_unit_item
      case store_unit_item.option
        when -1
           (store_unit_item.count && store_unit_item.count > 0 ? store_unit_item.count : "Под заказ")
        when 0
          "По запросу"
        when 1
          store_unit_item.count  
        else  
          store_unit_item.count > 0 ? store_unit_item.count : ""
      end
    end
    
    def total_store_count product
       product.store_count > 0 ? product.store_count.to_s + " шт." : (product.cached_store_units.count{|x| x.option == -1} > 0 ? "под заказ" : "по запросу")
    end
end
