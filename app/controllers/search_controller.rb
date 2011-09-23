#encoding:utf-8;
class SearchController < ApplicationController
    helper_method :can_ext_search?
    
    before_filter :load_search_data
  
    def index
     params[:per_page] ||="20"
     params[:page] ||=1
     if params[:request].present?
      res = can_ext_search? ? Product.search_with_article(params[:request]) : Product.search(params[:request])
      res = res.where(:supplier_id =>  session[:flt_supplier_id]) if session[:flt_supplier_id]
      @products = res.paginate(:page => params[:page], :per_page => params[:per_page])
    elsif    
      price = []
      price[0] = params[:price_from].to_i
      price[1] = params[:price_to].to_i
      
      s_options =  if can_ext_search?    
       opts =  {:article => params[:article], :search_text => params[:name],:category => params[:category_ids], :manufactor => params[:manufactor_ids], :supplier => params[:supplier_ids], :eq => params[:eq]}
       opts.merge!(params.select{ |k,v| k =~ /pv_\d+/ && v.reject(&:blank?).present? })
     else
       opts = {:search_text => params[:name], :eq => params[:eq]}
       opts.merge!(params.select{ |k,v| k == "pv_#{@color.id}" && v.reject(&:blank?).present? })
     end
       
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
      res = s_options.empty? ? [] :  Product.find_all(s_options, "ext-search")
      
      @products = res.present? ? res.paginate(:page => params[:page], :per_page => params[:per_page]) : []      
    end      
  end
  
  protected
  
  def can_ext_search?
    ext_user?
  end
  
  private
  
  def load_search_data
    if can_ext_search?
      @categories = Category.cached_catalog_categories
      @suppliers = Supplier.order("name")
      @manufactors =  Manufactor.cached_active_manufactors
      @infliction = Property.where(:name => "Нанесение").first      
      @material = Property.where(:name => "Материал").first            
    end
    @color = Property.where(:name => "Цвет").first         
  end
end
