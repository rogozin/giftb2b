class ForeignController < ApplicationController
 #before_filter :check_acccess
  def index
      render "index" , :layout => "foreign"
  end

  def show
    @category = Category.find_by_permalink(params[:id])
    params[:page] ||=1
    @products = Product.find_all({:page=>params[:page], :per_page=>params[:per_page], :category=> @category.id})
    render 'foreign/show', :layout => "foreign"
  end

  def product
    @product = Product.find_by_permalink(params[:id])
    render "products/show"
  end
  
  def tree
    render :layout => false
  end
  
  def search
     @products = Product.find_all( {:search_text =>params[:request], :page => params[:page]  }) unless params[:request].blank?
     render :layout => false
  end
  
  def virtual
    render :template => "shared/_catalog_img", :layout => false    
  end

private
  def check_acccess 
    
    render :text=>"", :layout => "access_denied" unless ForeignAccess.accepted_clients.map(&:ip_addr).include? request.remote_addr

  end

end
