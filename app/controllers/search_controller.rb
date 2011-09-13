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
      
      s_options = {:article => params[:article], :search_text => params[:name],:category => params[:category_ids], :manufactor => params[:manufactor_ids], :supplier => params[:supplier_ids], :eq => params[:eq]}
       
       s_options.merge!(params.select{ |k,v| k =~ /pv_\d+/ && v.reject(&:blank?).present? })
       if params[:price_from] == "по запросу"
         s_options.merge!(:price => "0") 
       elsif  price[0] > price[1] 
         s_options.merge!(:price => price[0]) 
       elsif price[1] > price[0]
         s_options.merge!(:price_range => price)
       end
       
       s_options.merge!(:store => params[:store_from]) if params[:store_from].to_i > 0
      
       s_options.merge!(:store => 0) if params[:on_demand]
       s_options.merge!(:store => -1) if params[:in_order]
        
      
      s_options.delete_if{ |k, v| v.blank?}
      logger.info "=================== #{s_options}"
      res = s_options.empty? ? [] :  Product.find_all(s_options, "ext-search")
      
      @products = res.present? ? res.paginate(:page => params[:page], :per_page => params[:per_page]) : []
      @categories = Category.cached_catalog_categories
      @suppliers = Supplier.order("name")
      @manufactors =  Manufactor.cached_active_manufactors
      @infliction = Property.where(:name => "Нанесение").first      
      @material = Property.where(:name => "Материал").first      
      @color = Property.where(:name => "Цвет").first      
    end      
  end
  
  
end
