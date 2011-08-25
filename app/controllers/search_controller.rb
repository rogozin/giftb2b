#encoding:utf-8;
class SearchController < ApplicationController
  
  
    def index
     params[:per_page] ||="20"
     params[:page] ||=1
     if params[:request].present?
      res = (current_user && (current_user.is_firm_user? || current_user.is_admin_user?) ? Product.search_with_article(params[:request]) : Product.search(params[:request]))
      res = res.where(:supplier_id =>  session[:flt_supplier_id]) if session[:flt_supplier_id]
      @products = res.paginate(:page => params[:page], :per_page => params[:per_page])
    elsif current_user && (current_user.is_firm_user? || current_user.is_admin?)
      price = []
      price[0] = params[:price_from].to_i
      price[1] = params[:price_to].to_i
      
      s_options = {:article => params[:article], :search_text => params[:name],:category => params[:category_ids], :manufactor => params[:manufactor_ids]}
       
       s_options.merge!(params.select{ |k,v| k =~ /pv_\d+/ })
       if params[:price_from] == "по запросу"
         s_options.merge!(:price => "0") 
       elsif  price[0] > price[1] 
         s_options.merge!(:price => price[0]) 
       elsif price[1] > price[0]
         s_options.merge!(:price_range => price)
       end
       
       if params[:store_from] == "по запросу"
         s_options.merge!(:store => "0") 
      elsif params[:store_from].to_i > 0
         s_options.merge!(:store => params[:store_from]) 
       end
      
      res = Product.find_all(s_options, "ext-search")
      @products = res.paginate(:page => params[:page], :per_page => params[:per_page])
      @properties = Property.active.for_search
      @categories = Category.catalog.roots
      @manufactors =  Manufactor.order("name")
    end      
  end
  
  
end
