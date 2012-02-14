#encoding: utf-8;
class Lk::ProductsController < Lk::BaseController
  access_control do
     allow :admin, :lk_product
  end
  
  before_filter :find_lk_product, :only => [:edit, :update, :destroy]
  before_filter :load_categories, :only => [:index, :edit, :update, :new, :create, :load_lk_products]
  before_filter :load_my_category_ids, :only => [:index, :load_lk_products]
  
  def index
    params[:page] ||= "1"
    params[:per_page] ||= "10"
    if current_user.firm_id.present?
      @products = set_filter.paginate(:page => params[:page], :per_page => params[:per_page])
    else 
      @products  = []
      not_firm_assigned!
    end
  end
  
  def new
    @product = LkProduct.new()
  end
  
  def create
    @product = LkProduct.new(params[:lk_product])
    @product.firm_id = current_user.firm_id
    if @product.save
      flash[:notice] = "Товар успешно добавлен!"
      redirect_to edit_product_path(@product)
    else
      render 'new'
    end
  end
  
  def update
    params[:lk_product][:category_ids] ||= []
    if @product.update_attributes(params[:lk_product])
      flash[:notice] = "Товар изменен!"
      redirect_to (params[:redirect].present? ?  params[:redirect] :  edit_product_path(@product))
    else
      render 'edit'
    end
  end
 
 def destroy
   flash[:alert] = "Товар не может быть удален, потому что он используется в каком-либо коммерческом предложении или заказе!" unless @product.can_destroy?
   flash[:notice] = "Товар удален!" if @product.can_destroy? && @product.destroy
   redirect_to products_path
   
 end
 
 def find_lk_product
   @product = LkProduct.where(:firm_id => current_user.firm_id).find(params[:id])
 end
 
   def load_lk_products
    params[:page] ||="1"
    params[:per_page] ||= "20"
    @object_type = params[:object_type]
    #@object_id = params[:object_id]
    set_post_url    
    @lk_products = set_filter.paginate(:page => params[:page], :per_page => params[:per_page])
  end
 
  def load_my_category_ids
    @category_ids = LkProductCategory.joins(:lk_product).where("lk_products.firm_id" => current_user.firm.id).map(&:category_id).uniq
  end

  def set_filter
    res = LkProduct.active.where(:firm_id => current_user.firm.id)
    res = res.search(params[:request]) if params[:request]
    res = res.by_category(params[:category_ids]) if params[:category_ids]    
    res
  end
  
 private :find_lk_product, :load_categories, :load_my_category_ids, :set_filter
 
end
