#encoding: utf-8;
class Lk::CommercialOfferItemsController < Lk::BaseController
  access_control do
     allow :admin, :lk_co
  end
  
  before_filter :find_co, :except => [:calc_single]
  before_filter :find_co_item, :except => [:create, :new]
  before_filter :load_categories, :only => [:edit, :update]
  
  
  
  def edit
    @product = @commercial_offer_item.lk_product
  end
  
  def calc_single    
    @commercial_offer = @commercial_offer_item.commercial_offer
    if params[:quantity].to_i >0
      @commercial_offer_item.update_attribute :quantity, params[:quantity]
    else
      @commercial_offer_item.destroy
    end     
  end
  
  def destroy
    flash[:notice] = "Товар исключен из коммерческого предложения!" if @commercial_offer_item.destroy
    redirect_to commercial_offer_path(@commercial_offer)
  end
  
  private
  def find_co
    @commercial_offer = CommercialOffer.where(:firm_id => current_user.firm_id).find(params[:commercial_offer_id])
  end
  
  def find_co_item
    @commercial_offer_item = CommercialOfferItem.find(params[:id])
  end
end
