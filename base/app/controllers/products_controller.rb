#encoding: utf-8;
class ProductsController < BaseController
  before_filter :require_ra_user 
  def show
      @product = Product.find_by_permalink(params[:id])
      return not_found unless @product
  end

end
