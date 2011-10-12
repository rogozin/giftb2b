#encoding: utf-8;
require 'cart'
require 'cart_item'
require 'product'
require 'attach_image'
require 'image'

class CartController < BaseController
 before_filter :require_user
  before_filter :get_cart, :except => [:empty]
  
  def index
    @firms = Firm.where_city_present
    @lk_order = LkOrder.new(flash[:lk_order])
  end
  
 def add
    begin
      product=Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Попытка доступа к несуществующему товару #{params[:id]}")
    else
      @current_item = @cart.add_product(product)
    end
  end

  def destroy
    @cart.items.find{|i| i.product.id == params[:id].to_i }.quantity= 0
    @cart.optimize!
    respond_to do |format|
      format.js {render 'cart_items.js'}
      format.html {redirect_to cart_index_path}
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
    params[:cart_items].each do |product_id, quantity| 
      @cart.items.find{|i| i.product.id == product_id.to_i }.quantity= quantity.to_i
    end
    @cart.optimize!
    respond_to do |format|
      format.js {render 'cart_items.js'}
      format.html {redirect_to cart_index_path}
    end     
  end
  
  private
  
  def get_cart
    @cart = find_cart
  end
 
end
