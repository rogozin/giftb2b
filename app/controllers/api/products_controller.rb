class Api::ProductsController < Api::BaseController
  
  def index
    params[:page] ||=1
    @products = if params[:category].to_i > 0
      Product.find_all({:category=> params[:category] }, "json").paginate(:page => params[:page])
    else
      Product.active
    end
    respond_with @products  
  end
  
  def show
    @product = Product.find_by_permalink(params[:id])
    respond_with(@product)
  end
end
