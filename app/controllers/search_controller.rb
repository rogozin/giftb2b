#encoding:utf-8;
class SearchController < ApplicationController
  
    def index
     params[:per_page] ||="20"
     params[:page] ||=1
     if params[:request].present?
      res = (current_user && (current_user.is_firm_user? || current_user.is_admin_user?) ? Product.search_with_article(params[:request]) : Product.search(params[:request]))
      res = res.where(:supplier_id =>  session[:flt_supplier_id]) if session[:flt_supplier_id]
      @products = res.paginate(:page => params[:page], :per_page => params[:per_page])
    else 
      price = get_slider_param(:price)
      store_count = get_slider_param(:store_count)
      
      s_options = {:article => params[:article], :search_text => params[:name],:category => params[:category_ids], :price_range => price, :store_count_range => store_count}
       
       s_options.merge!(params.select{ |k,v| k =~ /pv_\d+/ })
       s_options.merge!(:price => "0") if params[:price] == "по запросу"
       s_options.merge!(:store => "0") if params[:store_count] == "по запросу"
      
      res = Product.find_all(s_options, "ext-search")
      @products = res.paginate(:page => params[:page], :per_page => params[:per_page])
      @properties = Property.active.for_search
      @categories = Category.catalog.roots
    end      
  end
  
  
  private 
  
    def get_slider_param(param_name)
       params[param_name].present? && params[param_name] != "по запросу" ? params[param_name].split('-').map(&:to_i)[0..1].sort : []
    end
end
