#encoding: utf-8;
class ProductsController < BaseController
  before_filter { |controller| controller.authenticate_user! if  giftpoisk?}
   
  def show
    @product = Product.find_by_permalink(params[:id])
    return not_found unless @product
    current_user ? expires_now :  expires_in(1.minutes, :public => true)
    fresh_when(:etag => @product, :last_modified => @product.updated_at, :public => true) unless current_user     
  end

end
