#encoding: utf-8;
module Auth

  module ControllerMix
      
    def giftpoisk?
      Settings.giftpoisk?
    end
      
    def giftb2b?
      Settings.giftb2b?
    end   
  
    def store_location
      session[:return_to] = request.fullpath
    end
  
    def ext_user?
      current_user && (current_user.is?(:catalog) || current_user.is_admin?) 
    end

    def load_search_data
     if ext_user? || giftpoisk?
        @categories = Category.cached_catalog_categories
        @thematic  = Category.cached_thematic_categories
        @analogs  = Category.cached_analog_categories
        @suppliers = current_user ? Supplier.where(:id => current_user.assigned_supplier_ids).order("name") : Supplier.order("name")
        @manufactors =  Manufactor.cached_active_manufactors
        @infliction = Property.where(:name => "Нанесение").first      
        @material = Property.where(:name => "Материал").first            
      end
      @color = Property.where(:name => "Цвет").first             
    end           
  end
end
