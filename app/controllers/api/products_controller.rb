#encoding: utf-8;
class Api::ProductsController < Api::BaseController
  
  def index
    params[:page] ||=1
    params[:per_page] ||=30
    params[:per_page] = 100 if params[:per_page].to_i > 100
    @products = if params[:category].to_i > 0

     res1 =  Product.active.sorted.all_by_category Category.tree_childs(Category.cached_active_categories, params[:category].to_i)
     res2 = @firm.present? ? LkProduct.for_my_site(@firm.id) : []
     res1 + res2
    else
      Product.active.sorted
    end
    respond_with @products.paginate(:page => params[:page], :per_page => params[:per_page])
  end
  
  def show
    @product = []
    @product = is_lk_product? ? find_lk_product : Product.find_by_permalink(params[:id])
    respond_with(@product)
  end
  
  def by_id
    @product = is_lk_product ? find_lk_product : Product.find(params[:id])
    respond_with(@product)
  end

end
