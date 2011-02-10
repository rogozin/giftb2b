require 'cart'
require 'cart_item'
require 'product'
require 'attach_image'
require 'image'

class CartController < ApplicationController
  def index
    @cart = find_cart
    @lk_firms = LkFirm.find_all_by_firm_id(current_user.firm_id) if current_user.is_firm_user?
  end
  
 def add
    begin
      product=Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Попытка доступа к несуществующему товару #{params[:id]}")
    else
      @cart=find_cart
      @current_item = @cart.add_product(product)
    end
  end

  def empty
    session[:cart] = nil
    respond_to do |format|
      format.js {render 'add.js'}
      format.html {redirect_to root_path}
    end 
  end
  
  def calculate
    @cart = find_cart
    params[:cart_items].each do |product_id, quantity| 
      @cart.items.find{|i| i.product.id == product_id.to_i }.quantity= quantity.to_i
    end
    @cart.optimize
    respond_to do |format|
      format.js {render 'cart_items.js'}
      format.html {redirect_to cart_index_path}
    end 
    
  end
 
end