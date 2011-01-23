class Lk::CommercialOffersController < Lk::BaseController
  access_control do
     allow :Администратор, "Менеджер фирмы", "Пользователь фирмы"
  end
  
  before_filter :find_co, :except => [:index]
  
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


  private
  
  def find_co
    @commercial_offer = CommercialOffer.find(params[:id])
  end
end
