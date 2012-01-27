#encoding: utf-8;
class Api::CategoriesController < Api::BaseController
  def index
    @categories = Category.cached_catalog_categories   
    #puts request.headers
    expire_cache(300)    
    respond_with(@categories)
  end
  
  def show
    @category=[]
    @category = Category.find_by_permalink(params[:id])
    expire_cache(300)
    respond_with(@category)    
  end
  
  def analogs
    @categories = Category.cached_analog_categories
    expire_cache(300)    
    respond_with(@categories)        
  end
  
  def thematics
    @categories = Category.cached_thematic_categories
    expire_cache(300)    
    respond_with(@categories)        
  end
  
  def virtuals
    @categories = Category.cached_virtual_categories
    expire_cache(300)    
    respond_with(@categories)          
  end
end
