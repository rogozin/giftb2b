#encoding: utf-8;
class Api::ProductsController < Api::BaseController
  
  def index
    params[:page] ||=1
    params[:per_page] ||=30
    params[:per_page] = 100 if params[:per_page].to_i > 100
    @products = if params[:category].to_i > 0
    cat = Category.find(params[:category])
    Rails.cache.fetch("#{cat.cache_key}/products/per_page_#{params[:per_page]}/page_#{params[:page]}") { Product.active.sorted.all_by_category(Category.tree_childs(Category.cached_active_categories, params[:category].to_i)).paginate(:page => params[:page], :per_page => params[:per_page]).all}
    else
      []
    end
   respond_with @products
  end
  
  def lk
     params[:page] ||=1
    params[:per_page] ||=30
    params[:per_page] = 100 if params[:per_page].to_i > 100
    @products=[]
    if @firm
      @products = if params[:category].to_i > 0
        LkProduct.for_my_site(@firm.id).by_category(Category.tree_childs(Category.cached_active_categories, params[:category].to_i)).paginate(:page => params[:page], :per_page => params[:per_page]) 
      else
        LkProduct.for_my_site(@firm.id).paginate(:page => params[:page], :per_page => params[:per_page])  
      end
    end
    respond_with @products
  end

  def show
    @product = []
    @product = is_lk_product? ? find_lk_product : Product.active.find_by_permalink(params[:id])
    respond_with(@product)
  end
  
  def by_id
    @product = is_lk_product? ? find_lk_product : Product.find(params[:id].to_i)
    respond_with(@product)
  end
  
  def novelty
    @products = Product.cached_novelty
    respond_with(@products)          
  end
  
  def sale
    @products = Product.cached_sale
    respond_with(@products)          
  end

end
