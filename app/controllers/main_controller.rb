class MainController < ApplicationController
  def index 

  end

  
  def search
    @products = Product.search params[:search][:request]
  end


end
