class Api::CategoriesController < Api::BaseController
  def index
    @categories = Category.catalog    
    respond_with(@categories)
  end
  
  def show
    @category = Category.find_by_permalink(params[:id])
    respond_with(@category)    
  end
  
  def analogs
    find_categories 3
    respond_with(@categories)        
  end
  
  def thematics
    find_categories 2
    respond_with(@categories)        
  end
  
  def virtuals
     find_categories 0
    respond_with(@categories)          
  end



  private 
  
  def find_categories(kind)
    @categories = Category.cached_active_categories.select{|cat| cat.kind == kind}     
  end

end
