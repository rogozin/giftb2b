module XmlSettings

 class << self
  def  fields_hash
    {:article =>"product_sku", :short_name=>"product_name", :full_name=> "", :size=>"product_size", :color=> "product_color",
      :factur => "product_material", :box => "product_box", :price => "product_price", :currency_type => "product_currency", 
      :from_store =>"product_stock", :store_count=>"product_in_stock", :meta_description => "meta_description", :meta_keywords=> "meta_keywords", :description => "product_desc", :is_new => "is_new", :is_sale => "is_sale"
    }
  end
  end
  
end  
