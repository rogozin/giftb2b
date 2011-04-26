class ForeignController < ApplicationController
 before_filter :check_acccess
 before_filter :find_category, :except => [:thematic_tree, :analog_tree, :search, :virtual]
  def index
   render "index" , :layout => "foreign"
  end

  def show
    @category = Category.find_by_permalink(params[:id])
    params[:page] ||=1
    @products = Product.find_all({:page=>params[:page], :per_page=>params[:per_page], :category=> @category.id, :active => true})
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
    @permalink = params[:selected]
    @categories = Category.cached_active_categories.select{|cat| cat.kind==2}
    render :layout => "single"
  end
  
  def analog_tree
    @permalink = params[:selected]  
    @categories = Category.cached_active_categories.select{|cat| cat.kind==3}    
    render :layout => "single"
  end
  
  def search
    params[:per_page] ||="20"
     @products = Product.search(params[:request]).paginate(:page => params[:page], :per_page => params[:per_page]) unless params[:request].blank?
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
