#encoding: utf-8;
module CategoriesHelper
  def treeview_selected(current_permalink)
    session[:category_location] && session[:category_location] == current_permalink ?  "selected" : nil 
  end
  
  def hashed_categories_tree(categories_hash,  checked_items, init = true, expand_block = false,  field_name = "lk_product[category_ids]")

    res = init ? "<ul class='treeview'>\n" : (expand_block ? "<ul>\n" : "<ul style='display:none;'>\n")
      categories_hash.each do |category|
       res << "<li>"
       res += check_box_tag("#{field_name}[]", category[:id],checked_items.include?(category[:id]), :id => "#{field_name}_cat_#{category[:id]}" ) +" " + 
       (category[:children].present? ? link_to(category[:name], "#", :class => "toggle-category") : label_tag("#{field_name}_cat_#{category[:id]}", category[:name]))
       res << hashed_categories_tree(category[:children], checked_items, false, find_value(category, checked_items).present?, field_name) if category[:children].present?
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
  
  def tree_ul_from_hash(categories_hash, init=true, &block)
    res = init ? "<ul class='b-tree'>\n" : "<ul>\n"
      categories_hash.each do |category|
       res << "<li>"
       res += block_given? ? yield(category) : category[:name]
       res << tree_ul_from_hash(category[:children],false, &block) if category[:children].present?
       res << "</li>\n"
      end
    res << "</ul>\n"
    raw res  
  end  
end
