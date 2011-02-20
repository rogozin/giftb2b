class MainController < ApplicationController
  def index 
    @new_products = Product.cached_novelty
  end

  
  def search
    @products = (current_user && (current_user.is_firm_user? || current_user.is_admin_user?) ? Product.search_with_article(params[:request]) : Product.search(params[:request])).paginate(:page => params[:page])
  end


end
