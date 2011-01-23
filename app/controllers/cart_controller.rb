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
  
  def generate_co
    @cart = find_cart
    @co = CommercialOffer.new(params[:commercial_offer])
    @co.firm = current_user.firm
    @co.user = current_user
    if @co.save
     flash[:notice] = "Коммерческое предложенеие сгенерировано на основе набора товаров Вашей корзины." 
     @cart.items.each do |item|
       lk_product = copy_product_to_lk(item.product, @co.firm_id, item.price)
       @co.commercial_offer_items.create({:lk_product=>lk_product, :quantity => item.quantity})
      end
      redirect_to lk_commercial_offer_path(@co)
    else 
      flash[:error] = "Коммерческое предложение не может быть сгенерировано!" 
      redirect_to cart_index_path
    end  
    
  end

  private 
  
  def copy_product_to_lk(product, firm_id, price=0, active=false)
    lk_product = LkProduct.new({ 
      :firm_id => firm_id, 
      :product_id => product.id,
      :article => product.unique_code,
      :short_name => product.short_name,
      :description => product.description,
      :price => price == 0 ? product.price_in_rub : price,
      :color => product.color, 
      :size => product.size,
      :factur => product.factur,
      :box => product.box,
      :active => active,
      :infliction => product.property_values.select{|p| p.property.name="Нанесение"}.map(&:value).join(' ,') })
    img = product.main_image
    begin
    if img
      File.open(img.picture.path) do  |file| 
        lk_product.picture = file
      end      
    end
    rescue
        lk_product.picture = File.open(Rails.root.to_s + "/public/images/default_image.jpg")
    end    
    lk_product.save 
    lk_product
  end
  
  def find_cart    
    session[:cart] ||= Cart.new          
  end
end
