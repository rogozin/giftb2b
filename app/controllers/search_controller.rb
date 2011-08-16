class SearchController < ApplicationController
  
    def index
     if params[:request].present?
      res = (current_user && (current_user.is_firm_user? || current_user.is_admin_user?) ? Product.search_with_article(params[:request]) : Product.search(params[:request]))
      res = res.where(:supplier_id =>  session[:flt_supplier_id]) if session[:flt_supplier_id]
      @products = res.paginate(:page => params[:page], :per_page => params[:per_page] || "20")
      render 'result'
    else 
      @properties = Property.active.for_search
      @categories = Category.catalog.roots
      render 'index'
    end
    
    
  end
  
end
