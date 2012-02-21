#encoding: utf-8;
class CategoriesController < BaseController
 before_filter :require_ra_user  
def show
    @category = Category.find_by_permalink(params[:id])
    return not_found unless @category
    return render "virtual" if @category.is_virtual?
    session[:category_location] = @category.permalink   
    params[:page] ||="1"
    params[:per_page] ||= "20"
    @products = Product.find_all({:category=> @category.id }, "categories")
    @products = @products.where(:supplier_id => current_user.assigned_supplier_ids) if giftpoisk?    
    @products = @products.paginate(:page => params[:page], :per_page=>params[:per_page])
 #   fresh_when(:etag => @category, :last_modified => @products.max_by(&:updated_at).try(:updated_at) || @category.updated_at, :public => true) unless current_user         
end

  def on_sale
    params[:page] ||=1
    @title = "Ликвидация остатков"
    @products = Product.find_all({:sale => "1"}, "categories")
    @products = @products.paginate(:page => params[:page], :per_page => params[:per_page])
    render :products
 #   fresh_when(:etag => @category, :last_modified => @products.max_by(&:updated_at).try(:updated_at) || Time.now, :public => true) unless current_user             
  end

  def best_price
    params[:page] ||=1
    @title = "Отличная цена"
    @products = Product.find_all({:best_price => "1"}, "categories")
    @products = @products.paginate(:page => params[:page], :per_page => params[:per_page])
    render :products
 #   fresh_when(:etag => @category, :last_modified => @products.max_by(&:updated_at).try(:updated_at) || Time.now, :public => true) unless current_user             
  end
  
end
