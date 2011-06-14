class Api::ProductsController < Api::BaseController
  
  def index
    params[:page] ||=1
    params[:per_page] ||=30
    params[:per_page] = 100 if params[:per_page].to_i > 100
    @products = if params[:category].to_i > 0

      Product.active.all_by_category Category.tree_childs(Category.cached_active_categories, params[:category].to_i)
    else
      Product.active
    end
    respond_with @products.paginate(:page => params[:page], :per_page => params[:per_page])
  end
  
  def show
    @product = Product.find_by_permalink(params[:id])
    respond_with(@product)
  end
  
  def by_id
    @product = Product.find(params[:id])
    respond_with(@product)
  end
end
