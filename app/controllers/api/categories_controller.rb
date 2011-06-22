class Api::CategoriesController < Api::BaseController
  def index
    @categories = Category.cached_catalog_categories
    
    #puts request.headers
    respond_with(@categories)
  end
  
  def show
    @category = Category.find_by_permalink(params[:id])
    respond_with(@category)    
  end
  
  def analogs
    @categories = Category.cached_analog_categories
    respond_with(@categories)        
  end
  
  def thematics
    @categories = Category.cached_thematic_categories
    respond_with(@categories)        
  end
  
  def virtuals
    @categories = Category.cached_virtual_categories
    respond_with(@categories)          
  end
end
