class ProductsController < ApplicationController
  def show
      @product = Product.find_by_permalink(params[:id])
  end

end
