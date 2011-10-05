#encoding: utf-8;
class Lk::CommercialOfferItemsController < Lk::BaseController
  access_control do
     allow :Администратор, "Менеджер фирмы", "Пользователь фирмы"
  end
  
  before_filter :find_co
  before_filter :find_co_item, :except => [:create, :new]
  before_filter :load_categories, :only => [:edit, :update]
  
  
  
  def edit
    @product = @commercial_offer_item.lk_product
  end
  
  def destroy
    flash[:notice] = "Товар исключен из коммерческого предложения!" if @commercial_offer_item.destroy
    redirect_to commercial_offer_path(@commercial_offer)
  end
  
  private
  def find_co
    @commercial_offer = CommercialOffer.find(params[:commercial_offer_id])
  end
  
  def find_co_item
    @commercial_offer_item = CommercialOfferItem.find(params[:id])
  end
end
