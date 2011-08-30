#encoding: utf-8;
class ProductsController < ApplicationController
  def show
      @product = Product.find_by_permalink(params[:id])
      return not_found unless @product
  end

end
