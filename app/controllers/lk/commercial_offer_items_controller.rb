class Lk::CommercialOfferItemsController < Lk::BaseController
  access_control do
     allow :Администратор, "Менеджер фирмы", "Пользователь фирмы"
  end
  
  before_filter :find_co
  before_filter :find_co_item, :except => [:create, :new]
  
  def edit
    @commercial_offer_product = @commercial_offer_item
  end
  
  def update
    if @commercial_offer_item.update_attributes(params[:commercial_offer_item])
      flash[:notice] = "Товар изменен!"
      redirect_to edit_lk_commercial_offer_product_path(@commercial_offer, @commercial_offer_item)
    else  
      render 'edit'
    end  
  end
  
  def new
    
  end
  
  def create
    
  end
  
  def destroy
    flash[:notice] = "Товар исключен из коммерческого предложения!" if @commercial_offer_item.destroy
    redirect_to lk_commercial_offer_path(@commercial_offer)
  end
  
  private
  def find_co
    @commercial_offer = CommercialOffer.find(params[:commercial_offer_id])
  end
  
  def find_co_item
    @commercial_offer_item = CommercialOfferItem.find(params[:id])
  end
end
