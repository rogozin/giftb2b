#encoding: utf-8;
class CategoriesController < ApplicationController

def show
    @category = Category.find_by_permalink(params[:id])
    return render "virtual" if @category.is_virtual?
    session[:category_location] = @category.permalink
#    @ltp = url_for(:only_path => false, :controller => controller_name, :action => action_name, :id => @category.permalink, :page=>params[:page], :per_page=>params[:per_page])    
    params[:page] ||=1
    if current_user && current_user.is_admin_user?
      if current_user.has_role?("Редактор каталога") 
        session[:flt_supplier_id] = current_user.supplier ? current_user.supplier.id : -1
      else
        session[:flt_supplier_id] = params[:supplier_id] || nil
      end
    end
    @products = Product.find_all({:page=>params[:page], :per_page=>params[:per_page], :category=> @category.id, :active => true, :supplier => session[:flt_supplier_id] })
    #render :template =>'categories/show', :layout => false if request.xhr?    
end

  def on_sale
    params[:page] ||=1
    @title = "Ликвидация остатков"
    @products = Product.find_all({:page => params[:page], :per_page => params[:per_page], :active => true, :sale => "1"})
    render :products
  end

  def best_price
    params[:page] ||=1
    @title = "Отличная цена"
    @products = Product.find_all({:page => params[:page], :per_page => params[:per_page], :active => true, :best_price => "1"})
    render :products
  end
  
end
