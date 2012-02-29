#encoding: utf-8;
class Lk::BaseController < Lk::ApplicationController
  before_filter :authenticate_user!, :load_search_data
  layout 'lk/application'
  
  def index
    
  end
  
  def not_firm_assigned!
    flash[:alert] = "Вам не назначена фирма!"
  end
  
  
  def load_cart_products
    @cart = find_cart
    set_post_url
    render 'lk/shared/load_cart_products.js'
  end
  
  def load_categories
    @catalog = Category.cached_catalog_categories
    @analogs = Category.cached_analog_categories
    @thematic = Category.cached_thematic_categories     
  end
  
  def set_post_url
    
    case params[:object_type]    
      when "LkOrder"
        @post_url = add_product_order_path(params[:id])
      when "LkCommercialOffer"
        @post_url = add_product_commercial_offer_path(params[:id])
    end
  end
     
  def check_firm
    raise Acl9::AccessDenied unless current_user.firm_id
  end   
     
     
  private :not_firm_assigned!
  protected :set_post_url, :load_categories, :check_firm
end
