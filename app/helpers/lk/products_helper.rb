module Lk::ProductsHelper
  
 def hashed_categories_tree(categories_hash,  checked_items, init=true, expand_block=false)
    res = init ? "<ul class='treeview'>\n" : (expand_block ? "<ul>\n" : "<ul style='display:none;'>\n")
      categories_hash.each do |category|
       res << "<li>"
       res += check_box_tag("lk_product[category_ids][]", category[:id],checked_items.include?(category[:id]), :id => "cat_#{category[:id]}" ) +" " + 
       (category[:children].present? ? link_to(category[:name], "#", :class => "toggle-category") : label_tag("cat_#{category[:id]}", category[:name]))
       res << hashed_categories_tree(category[:children], checked_items, false, find_value(category, checked_items).present?) if category[:children].present?
       res << "</li>\n"
      end
    res << "</ul>\n"
    raw res  
  end  
  
  
  def find_value(root_item, search, path=[], level=0)
    if search.include?(root_item[:id])
      path << root_item
      return path
    end
    
    if root_item[:children].present?
      path << root_item
      level+=1

      root_item[:children].each do |item|       

         if find_value(item,search, path, level).size > level
           path << item
           break path
         end
           
      end
       path.delete_at(path.size-1) if path.present?  
    end    
    path
  end  
  
end
