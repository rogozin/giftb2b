class CategoriesController < ApplicationController

def show
    @category = Category.find_by_permalink(params[:id])
    session[:category_location] = @category.permalink
    @ltp = url_for(:only_path => false, :controller => controller_name, :action => action_name, :id => @category.permalink, :page=>params[:page], :per_page=>params[:per_page])    
    params[:page] ||=1
    if current_user && current_user.is_admin_user?
      if current_user.has_role?("Редактор каталога") 
        session[:flt_supplier_id] = current_user.supplier ? current_user.supplier.id : -1
      else
        session[:flt_supplier_id] = params[:supplier_id] || nil
      end
    end
    @products = Product.find_all({:page=>params[:page], :per_page=>params[:per_page], :category=> @category.id, :supplier => session[:flt_supplier_id] })
    #render :template =>'categories/show', :layout => false if request.xhr?    
end

end
