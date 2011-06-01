class Api::ProductsController < Api::BaseController
  
  def index
    params[:page] ||=1
    @products = if params[:category]
      Product.active.joins(:product_categories).where("product_categories.category_id =?", params[:category]).paginate(:page => params[:page])
    else
      Product.active
    end
    #respond_with(@products)  
    render :json => @products
  end
  
  def show
    @product = Product.find_by_permalink(params[:id])
    respond_with(@product)
  end
end
