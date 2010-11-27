class ProductsController < ApplicationController
  def show
      @product = Product.find_by_permalink(params[:id])
      if request.xhr? 
        render :template => 'products/show', :layout => false        
      end
  end

end
