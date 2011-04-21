module CategoriesHelper
  def treeview_selected(current_permalink)
    session[:category_location] && session[:category_location] == current_permalink ?  "selected" : nil 
  end
  
end
