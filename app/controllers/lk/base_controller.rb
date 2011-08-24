#encoding: utf-8;
class Lk::BaseController < ApplicationController
  before_filter :require_user
  layout 'lk'

 
  
  def not_firm_assigned!
    flash[:alert] = "Вам не назначена фирма!"
  end
  
  
   def load_cart_products
    @cart = find_cart
    @object_name = params[:object_name]
    @object_id = params[:object_id]
    case params[:object_name]    
      when "LkOrder"
        @post_url = ""
      when "LkCommercialOffer"
        @post_url = add_product_lk_commercial_offer_path(params[:id])
    end
    render 'lk/shared/load_cart_products.js'
  end
  
  
  
  private :not_firm_assigned!
end
