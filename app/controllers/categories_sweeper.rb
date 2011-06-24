class CategoriesSweeper < ActionController::Caching::Sweeper
  observe Category
  
  def after_update(category)
    expire_fragment('virtual_categories_output')
  end
  
end
