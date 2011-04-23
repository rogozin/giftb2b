module CategoriesHelper
  def treeview_selected(current_permalink)
    session[:category_location] && session[:category_location] == current_permalink ?  "selected" : nil 
  end
  
  def catalog_children parent_category
    res = ""
    res << "<ul class='ul_r'>"
    parent_category.children.each_with_index do |category, ind|
       res << "<li class='li_r'>" if (ind % 7).zero?
       res << content_tag(:p,link_to(category.name, category_path(category), :class => "menu_left"))
       res << " "
       res << "</li>"if ((ind+1) % 7).zero? || parent_category.children.size == ind + 1
    end
    res << "</ul>"
    raw res
  end
  
end
