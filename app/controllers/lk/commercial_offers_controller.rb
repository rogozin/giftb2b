class Lk::CommercialOffersController < Lk::BaseController
  access_control do
     allow :Администратор, "Менеджер фирмы", "Пользователь фирмы"
  end
  
  def index
      if current_user.firm_id.present?
      @commercial_offers = CommercialOffer.find_all_by_firm_id(current_user.firm.id)
    else 
      @commercial_offers  = []
      flash[:error] = "Вам не назначена фирма!"
    end
  end

  def show
    @commercial_offer = CommercialOffer.find(params[:id])
  end
  
  def  destroy
    @commercial_offer = CommercialOffer.find(params[:id])
    flash[:notice] = "Коммерческое предложение удалено" if @commercial_offer.destroy
    redirect_to lk_commercial_offers_path
  end
  
  def calculate 
    @commercial_offer = CommercialOffer.find(params[:id])
    @commercial_offer.sale = params[:sale]
    flash[:error] = "Ошибка при пересчете!" unless @commercial_offer.save
    params[:co_items].each do |product_id, quantity|
      if quantity.to_i >0
        @commercial_offer.commercial_offer_items.find_by_product_id(product_id).update_attribute :quantity, quantity
      else
        @commercial_offer.commercial_offer_items.find_by_product_id(product_id).destroy
      end 
    end
    redirect_to lk_commercial_offer_path(@commercial_offer)  
  end

end
