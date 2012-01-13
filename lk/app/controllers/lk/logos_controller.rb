#encoding: utf-8;
class Lk::LogosController < Lk::BaseController
    access_control do
     allow :Администратор, "Менеджер фирмы", "Пользователь фирмы"
  end
  
  before_filter :find_co
  
  
  def show

  end
  
  # update lk_product picture
  def update
    encoded_image = params[:picture].sub('data:image/png;base64,', '')
    new_picture = StringIO.new( Base64.decode64(encoded_image))
    def new_picture.original_filename; "picture-with-logo-#{Time.now.to_s(:db).parameterize}"; end   
    @item.lk_product.update_attributes :picture => new_picture
    respond_to do |format|
      format.js { render :json => {:status => "ok", :picture => @item.lk_product.picture.url(:thumb)}}
      format.html {redirect_to commercial_offer_path(@commercial_offer) }
    end
  end
  
  
  # add new logo to canvas
  def load
    f = params[:picture]
    if %w(gif png jpeg bmp).include?(f.content_type.split("/").last)    
      @src = "data:" + f.content_type + ";base64," + Base64.encode64(f.read)
      @file_name = f.original_filename
   else 
     @message = "Неверный формат файла. Используйте png, jpg, gif или bmp."
   end
  end
  
  
  private 
  
  def find_co
    @commercial_offer = CommercialOffer.where(:firm_id => current_user.firm.id).find(params[:commercial_offer_id])
    @item = @commercial_offer.commercial_offer_items.find(params[:id])    
  end
  
end
