#encoding: utf-8;
class Lk::LogosController < Lk::BaseController
    access_control do
     allow :Администратор, "Менеджер фирмы", "Пользователь фирмы"
  end
  
  before_filter :find_co
  
  
  def show
    @item = @commercial_offer.commercial_offer_items.find(params[:id])
  end
  
  
  def update
    @item = @commercial_offer.commercial_offer_items.find(params[:id])
    encoded_image = params[:picture].sub('data:image/png;base64,', '')
    new_picture = StringIO.new( Base64.decode64(encoded_image))
    def new_picture.original_filename; "picture-with-logo"; end   
    @item.lk_product.update_attributes :picture => new_picture
    render :js => "ok"
  end
  
  
  private 
  
  def find_co
    @commercial_offer = CommercialOffer.where(:firm_id => current_user.firm.id).find(params[:commercial_offer_id])
  end
  
end
