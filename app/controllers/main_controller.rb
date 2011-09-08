#encoding: utf-8;
class MainController < ApplicationController
  def index 
    @scrollable_products = cached_novelty
  end

  def change_scrollable
   @scrollable_products =  params[:sale] ? cached_sale : cached_novelty
  end
  

  private

  def cached_novelty
    Rails.cache.fetch('novelty_products', :expires_in =>24.hours) { Product.active.novelty.all }
  end
  
  def cached_sale
    Rails.cache.fetch('sale_products', :expires_in =>24.hours) { Product.active.sale.all }
  end


end
