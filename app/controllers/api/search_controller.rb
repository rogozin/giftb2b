#encoding: utf-8;
class Api::SearchController < Api::BaseController
  
  def index
    params[:page] ||=1
    params[:per_page] ||=30
    params[:per_page] = 100 if params[:per_page].to_i > 100
    @products = []
    @products = Product.search(params[:q]).paginate(:page => params[:page], :per_page => params[:per_page]) if params[:q].length > 2
    
    #respond_with @products
    render :json => [{:products_size => @products.total_entries, :products => @products}]
  end
  
end
