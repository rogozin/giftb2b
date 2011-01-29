class Lk::CommercialOffersController < Lk::BaseController
  access_control do
     allow :Администратор, "Менеджер фирмы", "Пользователь фирмы"
  end
  
  before_filter :find_co, :except => [:index, :create]
  
  def index
      if current_user.firm_id.present?
      @commercial_offers = CommercialOffer.find_all_by_firm_id(current_user.firm.id)
    else 
      @commercial_offers  = []
       not_firm_assigned!
    end
  end
 
  def show
    @lk_products = LkProduct.active.find_all_by_firm_id(current_user.firm.id)
  end
  
  def export
    @commercial_offer = CommercialOffer.find(params[:id]) 
    render :layout => 'pdf'
  end

  def  destroy
    flash[:notice] = "Коммерческое предложение удалено" if @commercial_offer.destroy
    redirect_to lk_commercial_offers_path
  end
  
  def calculate 
    @commercial_offer.sale = params[:sale]
    flash[:error] = "Ошибка при пересчете!" unless @commercial_offer.save
    params[:co_items].each do |lk_product_id, quantity|
      if quantity.to_i >0
        @commercial_offer.commercial_offer_items.find_by_lk_product_id(lk_product_id).update_attribute :quantity, quantity
      else
        @commercial_offer.commercial_offer_items.find_by_lk_product_id(lk_product_id).destroy
      end 
    end
    redirect_to lk_commercial_offer_path(@commercial_offer)  
  end
  
  def add_product
     cnt = 0
     params[:lk_product_ids].each  do |lk_product_id|
      cnt +=1 if @commercial_offer.commercial_offer_items.create({:quantity => 1, :lk_product_id => lk_product_id})
     end
     flash[:notice] = "В коммерческое предложение #{Russian.p(cnt, "добавлен", "добавлено", "добавлены")} #{cnt} #{Russian.p(cnt, "товар", "товара", "товаров")}"
     redirect_to lk_commercial_offer_path(@commercial_offer) 
  end

  def create
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
      :infliction => product.property_values.select{|p| p.property.name=="Нанесение"}.map(&:value).join(' ,') })
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
  
  def find_co
    @commercial_offer = CommercialOffer.find(params[:id])
  end
end
