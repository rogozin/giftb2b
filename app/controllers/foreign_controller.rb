class ForeignController < ApplicationController
 before_filter :check_acccess
 before_filter :find_category, :except => [:thematic_tree, :analog_tree, :search, :virtual]
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
    render "foreign/product/show"
  end
  
  def tree
    render :layout => "single"
  end
  
  def thematic_tree
    @categories = Category.cached_active_categories.select{|cat| cat.kind==2}
    render :layout => "single"
  end
  
  def analog_tree
    @categories = Category.cached_active_categories.select{|cat| cat.kind==3}    
    render :layout => "single"
  end
  
  def search
     @products = Product.find_all( {:search_text =>params[:request], :page => params[:page]  }) unless params[:request].blank?
     render :layout => false
  end
  
  def virtual
    render   :layout => false    
  end

private
  def check_acccess 
    render :text=>"", :layout => "access_denied" unless ForeignAccess.accepted_clients.map(&:ip_addr).include? request.remote_addr
  end

  def find_category
    @categories = Category.cached_active_categories.select{|cat| cat.kind==1} 
  end
end
