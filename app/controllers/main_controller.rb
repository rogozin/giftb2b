class MainController < ApplicationController
  def index 
    @scrollable_products = Product.novelty
  end

  def change_scrollable
   @scrollable_products =  params[:sale] ? Product.sale : Product.novelty
  end
  
  def search
    @products = (current_user && (current_user.is_firm_user? || current_user.is_admin_user?) ? Product.search_with_article(params[:request]) : Product.search(params[:request])).paginate(:page => params[:page], :per_page => params[:per_page] || "20")
  end


end
