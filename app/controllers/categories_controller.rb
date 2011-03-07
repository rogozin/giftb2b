class CategoriesController < ApplicationController

def show
    @category = Category.find_by_permalink(params[:id])
    @ltp = url_for(:only_path => false, :controller => controller_name, :action => action_name, :id => @category.permalink, :page=>params[:page], :per_page=>params[:per_page])    
    params[:page] ||=1
    session[:flt_supplier_id] = params[:supplier_id] if params[:supplier_id] && current_user && current_user.is_admin_user?
    @products = Product.find_all({:page=>params[:page], :per_page=>params[:per_page], :category=> @category.id, :supplier => session[:flt_supplier_id] })
    #render :template =>'categories/show', :layout => false if request.xhr?    
end

end
