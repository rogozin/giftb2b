class MainController < ApplicationController
  def index 
    @scrollable_products = cached_novelty
  end

  def change_scrollable
   @scrollable_products =  params[:sale] ? cached_sale : cached_novelty
  end
  
  def search
    res = (current_user && (current_user.is_firm_user? || current_user.is_admin_user?) ? Product.search_with_article(params[:request]) : Product.search(params[:request]))
    res = res.where(:supplier_id =>  session[:flt_supplier_id]) if session[:flt_supplier_id]
    @products = res.paginate(:page => params[:page], :per_page => params[:per_page] || "20")
  end

  private

  def cached_novelty
    Rails.cache.fetch('novelty_products', :expires_in =>1.hours) { Product.novelty.all }
  end
  
  def cached_sale
    Rails.cache.fetch('sale_products', :expires_in =>1.hours) { Product.sale.all }
  end


end
