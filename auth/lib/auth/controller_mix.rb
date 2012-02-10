#encoding: utf-8;
module Auth

  module ControllerMix

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
  
    def require_user
      unless current_user
        store_location
        flash[:alert] = "Для доступа необходимо ввести имя пользователя и пароль"
        redirect_to auth_engine.login_path
        return false
      end
    end
  
    def giftpoisk?
      #ActionMailer::Base.default_url_options[:host] == "giftpoisk.ru"
      Settings.giftpoisk?
    end
      
    def giftb2b?
      #ActionMailer::Base.default_url_options[:host] == "giftb2b.ru"
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
