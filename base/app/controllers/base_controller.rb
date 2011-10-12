#encoding: utf-8;
class BaseController < ApplicationController
  
  helper_method :giftpoisk?, :giftb2b?
  
  
  
  protected
  
  def require_ra_user
     require_user if giftpoisk?
  end

  def load_search_data
    if ext_user? || giftpoisk?
      @categories = Category.cached_catalog_categories
      @suppliers = Supplier.order("name")
      @manufactors =  Manufactor.cached_active_manufactors
      @infliction = Property.where(:name => "Нанесение").first      
      @material = Property.where(:name => "Материал").first            
    end
    @color = Property.where(:name => "Цвет").first         
  end
  
end
