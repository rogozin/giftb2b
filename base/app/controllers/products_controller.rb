#encoding: utf-8;
class ProductsController < BaseController
  before_filter :require_ra_user 
  def show
      @product = Product.find_by_permalink(params[:id])
      return not_found unless @product
#      expires_in 1.minutes, :public => true unless current_user      
#     fresh_when(:etag => @product, :last_modified => @product.updated_at, :public => true) unless current_user     
  end

end
