
class Api::CategoriesController < Api::BaseController
  def index
    @categories = Category.cached_active_categories.select{|cat| cat.kind==1}
    respond_with(@categories)
  end
  
  def show
    @category = Category.find_by_permalink(params[:id])
    respond_with(@category)    
  end



end
