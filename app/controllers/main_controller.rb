class MainController < ApplicationController
  def index 

  end

  
  def search
    @products = Product.search(params[:request]).paginate(:page => params[:page])
  end


end
