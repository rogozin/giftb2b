module Lk::ProductsHelper
  
 def hashed_categories_tree(categories_hash, init=true, checked_items)
    res = init ? "<ul class='treeview'>\n" : "<ul style='display:none;'>\n"
      categories_hash.each do |category|
       res << "<li>"
       res += check_box_tag("lk_product[category_ids][]", category[:id],checked_items.include?(category[:id]), :id => "cat_#{category[:id]}" ) +" " + 
       (category[:children].present? ? link_to(category[:name], "#", :class => "toggle-category") : label_tag("cat_#{category[:id]}", category[:name])) 
       res << hashed_categories_tree(category[:children],false, checked_items) if category[:children].present?
       res << "</li>\n"
      end
    res << "</ul>\n"
    raw res  
  end  
  
end
