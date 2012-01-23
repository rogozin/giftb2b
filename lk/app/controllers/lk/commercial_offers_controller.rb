#encoding: utf-8;
require "excel"
class Lk::CommercialOffersController < Lk::BaseController
  access_control do
     allow :admin, :lk_co
  end
  include Gift::Export::Excel
  before_filter :find_co, :except => [:index, :create]
  before_filter :find_clients, :only => [:show, :calculate] 
  
  def index
    params[:page] ||=1
      if current_user.firm_id.present?
      @commercial_offers = CommercialOffer.where(:firm_id =>current_user.firm.id).order("id desc").paginate(:page => params[:page])
    else 
       not_firm_assigned!
    end
  end
 
  def show
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
  
  def update
    @commercial_offer.update_attributes(params[:commercial_offer])

    respond_to do |format|
      format.html { redirect_to commercial_offer_path(@commercial_offer), :notice => "Коммерческое предложение изменено" }
      format.js {render :text => "Ok", :status => :ok} 
    end
  end
  
  def modify
    alert = ""
    notice = ""
    alert << "Не выбраны товары для изменения стоимости" if  params[:co_items].blank?
    @co_items = []
    cnt_price = 0
    cnt_sale = 0
    if (params[:delta].present? || params[:logo].present? || params[:sale].present?) && params[:co_items].present?
      delta = params[:delta].to_i
      logo = params[:logo].to_i      
      sale = params[:sale].to_i
      params[:co_items].each do |id|
        co= CommercialOfferItem.find(id)
        p = co.lk_product
        val = p.price
        if p
          val += logo if logo
          val += params[:unit] == "1" ? (p.price * (delta.to_f/100)) :  delta 
          cnt_price +=1 if p.update_attributes(:price => val > 0 ?  val : 0) 
        end
        if co && params[:sale].present?
          cnt_sale += 1 if co.update_attributes(:sale =>  sale > 0 ? sale : 0) 
        end
        if co.valid? && p.valid?
          @co_items << co 
        else
          alert << co.errors.full_messages.join(', ')
        end
      end      
      notice << "Установлена скидка в размере #{sale}% для #{t(:product_p, :count => cnt_sale)}" if params[:sale].present? && cnt_sale > 0 
      notice << "Добавлено нанесение в размере #{logo} руб. для #{t(:product_p, :count => cnt_price)}" if params[:logo].present? && cnt_price > 0 
      notice << "Добавлена наценка в размере #{delta} #{params[:unit]=="1" ? "%" : "руб."} для #{t(:product_p, :count => cnt_price)}" if params[:delta].present? && cnt_price > 0 
      flash[:alert] = alert if alert.present?
      flash[:notice] = notice if notice.present?      
    end    
    respond_to do |format|
      format.js { render 'modify' }
      format.html { redirect_to commercial_offer_path(@commercial_offer)}
    end    
  end
  
  def calculate 
    params[:co_items].each do |id, quantity|
      @co_item = CommercialOfferItem.find(id)
      if quantity.to_i >0
        @co_item.update_attribute :quantity, quantity
      else
        @co_item.destroy
      end 
    end    
    flash[:notice] = "Коммерческое предложение пересчитано"
    respond_to do |format|
      format.js { }
      format.html {redirect_to commercial_offer_path(@commercial_offer) }
    end
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
    @co = CommercialOffer.new
    @co.firm_id = current_user.firm_id
    @co.user_id = current_user.id
    if @co.save
     flash[:notice] = "Коммерческое предложение сохранено. Вы можете внести в него правки." 
     @cart.items.each do |item|
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
  
  def find_clients
    @lk_firms = LkFirm.where(:firm_id => current_user.firm_id).order("name")
  end
  
end
