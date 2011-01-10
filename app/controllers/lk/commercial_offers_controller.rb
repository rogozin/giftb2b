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

  def edit
    @commercial_offer = CommercialOffer.find(params[:id])
  end
  
  def  destroy
    @commercial_offer = CommercialOffer.find(params[:id])
    flash[:notice] = "Коммерческое предложение удалено" if @commercial_offer.destroy
    redirect_to lk_commercial_offers_path
  end

end
