#encoding: utf-8;
class MainController < ApplicationController
  def index 
    @scrollable_products = Product.cached_novelty
  end

  def change_scrollable
   @scrollable_products =  params[:sale] ? Product.cached_sale : Product.cached_novelty
  end



end
