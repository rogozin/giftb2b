class CategoriesController < ApplicationController

def show
    @category = Category.find_by_permalink(params[:id])
    params[:page] ||=1
    @products = Product.find_all({:page=>params[:page], :per_page=>params[:per_page], :category=> @category.id})
    #render :template =>'categories/show', :layout => false if request.xhr?    
end

end
