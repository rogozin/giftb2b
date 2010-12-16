class CategoriesController < ApplicationController

def show
    @category = Category.find_by_permalink(params[:id])
    @ltp = url_for(:only_path => false, :controller => controller_name, :action => action_name, :id => @category.permalink, :page=>params[:page], :per_page=>params[:per_page])    
    params[:page] ||=1
    @products = Product.find_all({:page=>params[:page], :per_page=>params[:per_page], :category=> @category.id})
    #render :template =>'categories/show', :layout => false if request.xhr?    
end

end
