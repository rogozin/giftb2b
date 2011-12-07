#encoding: utf-8;
require "excel"
class Lk::CommercialOffersController < Lk::BaseController
  access_control do
     allow :Администратор, "Менеджер фирмы", "Пользователь фирмы"
  end
  include Gift::Export::Excel
  before_filter :find_co, :except => [:index, :create]
  
  def index
    params[:page] ||=1
      if current_user.firm_id.present?
      @commercial_offers = CommercialOffer.where(:firm_id =>current_user.firm.id).order("id desc").paginate(:page => params[:page])
    else 
       not_firm_assigned!
    end
  end
 
  def show
    @lk_firms = LkFirm.where(:firm_id => current_user.firm_id).order("name")
  end
  
  def export
    respond_to do |format|
    format.html {render  :layout => 'lk/pdf'}
    @hide_article = params[:sa] && params[:sa]== "0"
    @hide_description = params[:sd] && params[:sd]== "0"
    format.xls { 
       send_data(export_commercial_offer_with_pictures(@commercial_offer, @hide_article, @hide_description), :type => :xls, :filename => "commercial_offer_#{@commercial_offer.id}.xls")
       }
   end
  end

  def  destroy
    flash[:notice] = "Коммерческое предложение удалено" if @commercial_offer.destroy
    redirect_to commercial_offers_path
  end
  
  def calculate 
    flash_alert = ""
    @commercial_offer.sale = params[:sale]
    @commercial_offer.lk_firm_id = params[:lk_firm_id]
    @commercial_offer.signature = params[:signature]
    flash_alert << "Ошибка при пересчете. " unless @commercial_offer.save
    
    params[:co_items].each do |lk_product_id, quantity|
      if quantity.to_i >0
        @commercial_offer.commercial_offer_items.find_by_lk_product_id(lk_product_id).update_attribute :quantity, quantity
      else
        @commercial_offer.commercial_offer_items.find_by_lk_product_id(lk_product_id).destroy
      end 
    end
    
    flash_alert << "Не выбраны товары для изменения стоимости" if params[:delta].present? && params[:co_items_ids].blank?
    if params[:delta].present? && params[:co_items_ids].present?
      delta = params[:delta].to_i
      params[:co_items_ids].each do |lk_product_id|
         p = @commercial_offer.commercial_offer_items.where(:lk_product_id => lk_product_id).first.lk_product
         val = params[:unit] == "1" ? p.price + (p.price * (delta.to_f/100)) : p.price + delta if p 
         p.update_attribute(:price, val > 0 ?  val : 0) if p
      end
    end
    if flash_alert.present?
      flash[:alert] = flash_alert
    else
      flash[:notice] = "Коммерческое предложение изменено"
    end
    redirect_to commercial_offer_path(@commercial_offer)  
  end
  
  
  def add_product
     cnt = 0
     params[:lk_product_ids] ||=[]
     params[:cart_product_ids] ||=[]
     params[:lk_product_ids].each  do |lk_product_id|
      cnt +=1 if @commercial_offer.commercial_offer_items.create({:quantity => 1, :lk_product_id => lk_product_id})
     end
     params[:cart_product_ids].each do |cart_product_id|
       product = Product.find(cart_product_id)
       lk_product = LkProduct.copy_from_product(product, @commercial_offer.firm_id)
      cnt +=1 if @commercial_offer.commercial_offer_items.create({:lk_product=>lk_product, :quantity => 1})
     end
     
     if cnt > 0
       flash[:notice] = I18n.t(:co_added_products, :count => cnt) 
     else
       flash[:alert] = I18n.t(:co_added_products, :count => 0) 
     end
     
     redirect_to commercial_offer_path(@commercial_offer)
  end

  def create
    @cart = find_cart
    @co = CommercialOffer.new(:firm => current_user.firm, :user => current_user, :as => :admin)
    if @co.save
     flash[:notice] = "Коммерческое предложение сохранено. Вы можете внести в него правки." 
     @cart.items.each do |item|
       logger.info item.product.id
       lk_product = LkProduct.copy_from_product(item.product, @co.firm_id, item.start_price)
       @co.commercial_offer_items.create({:lk_product=>lk_product, :quantity => item.quantity})
      end
      @cart.items.clear
      redirect_to commercial_offer_path(@co)
    else 
      flash[:alert] = "Коммерческое предложение не может быть сгенерировано!" 
      redirect_to cart_index_path
    end      
  end

  def move_to_order
    @lk_order = LkOrder.create(:firm_id => @commercial_offer.firm_id, :lk_firm_id => @commercial_offer.lk_firm_id, :user => current_user, :user_comment => "Сгенерировано из коммерческого предложения № #{@commercial_offer.id}", :as => :admin)
    @commercial_offer.commercial_offer_items.each do |co_item|
      @lk_order.lk_order_items.create(:product => co_item.lk_product, :quantity => co_item.quantity, :price => co_item.lk_product.price)      
    end
    redirect_to edit_order_path(@lk_order), :notice => "Заказ успешно сгенерирован из коммерческого предложения"
  end

  private 
  
  
  def find_co
    @commercial_offer = CommercialOffer.where(:firm_id => current_user.firm.id).find(params[:commercial_offer_id] || params[:id])
  end
end
