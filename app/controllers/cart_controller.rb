require 'cart'
require 'cart_item'
require 'product'
class CartController < ApplicationController
  def index
    @cart = find_cart
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
  
  def generate_co
    @cart = find_cart
    @co = CommercialOffer.new(params[:commercial_offer])
    @co.firm = current_user.firm
    @co.user = current_user
    flash[:notice] = "Коммерческое предложенеие сгенерировано на основе набора товаров Вашей корзины." if @co.save
    for item in @cart.items
      @co.commercial_offer_items.create({:product_id=>item.product.id, :quantity => item.quantity, :price => item.start_price})
    end
    redirect_to edit_lk_commercial_offer_path(@co)
  end

  private 
  
  def find_cart    
    session[:cart] ||= Cart.new          
  end
end
