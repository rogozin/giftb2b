#encoding: utf-8;
module CategoriesHelper
  def treeview_selected(current_permalink)
    session[:category_location] && session[:category_location] == current_permalink ?  "selected" : nil 
  end
  
  
  def categories_columns(categories_hash, checked_items, columns_count =3, options={})
    categories_hash = categories_hash.sort{|x,y| x[:name] <=> y[:name]} if options.delete(:sort_parents)
    items_in_column = categories_hash.size / columns_count
    items_in_column += 1 if categories_hash.size % columns_count > 0
    res ="<ul class=\"b-column-container\">"
    columns_count.times do |index|
        from = index * items_in_column
        to  = from + items_in_column -1
        res << "<li class=\"li-column\">"
          res << hashed_categories_tree(categories_hash[from..to], checked_items, true, false, options)
        res <<"</li>"
    end
    res <<"</ul>"        
    raw res
  end
  
  def hashed_categories_tree(categories_hash,  checked_items, init = true, expand_block = false,  options = {})
    options[:class] ||= "treeview"
    options[:field_name] ||= "lk_product[category_ids]"
    options[:select_children] ||= false
    options[:sort_parents] ||= false    
    categories_hash = categories_hash.sort{|x,y| x[:name] <=> y[:name]} if init && options[:sort_parents]
    content_tag(:ul, :class => init ? options[:class] : nil, :style => !init && !expand_block ?  "display:none" : nil) do
      categories_hash.each do |category|
       concat raw("<li>")
      
       if category[:children].present? 
         concat smart_check_box_tag(options[:field_name], category[:id],checked_items.include?(category[:id])) if options[:select_children]
         concat link_to(category[:name], "#", :class => "toggle-category")         
         concat hashed_categories_tree(category[:children], checked_items, false, expand_block && find_value(category, checked_items).present?, options)
       else
         concat smart_check_box_tag(options[:field_name], category[:id],checked_items.include?(category[:id])) 
         concat " "
         concat label_tag( "cat_#{category[:id]}", category[:name])
       end
       concat raw("</li>\n")
      end
    end
    
  end  
  
  
  def smart_check_box_tag field_name, id, checked
    check_box_tag("#{field_name}[]", id ,checked, :id => "cat_#{id}" )
  end
  
  def min_categories_tree(categories_hash, used_values, checked_items, init = true, expand_block = false )
    content_tag(:ul, :class => init ? "treeview" : nil, :style => !init && !expand_block ?  "display:none" : nil) do
      categories_hash.each do |category|
        if find_value(category, used_values).present?
          concat raw("<li>")
          if category[:children].present?
            concat link_to(category[:name], "#", :class => "toggle-category pseudo-link")
            concat min_categories_tree(category[:children], used_values, checked_items, false, find_value(category, checked_items).present? )          
          else
            concat check_box_tag("category_ids[]", category[:id],checked_items.include?(category[:id]), :id => "lk_product_cat_#{category[:id]}" )
            concat " "
            concat label_tag("lk_product_cat_#{category[:id]}", category[:name])         
          end
       concat  raw("</li>\n")
       end
     end
    end
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
       res << content_tag(:li, :class => category[:outline] ? "category-outline" : nil) do
       concat block_given? ? yield(category) : category[:name]
       concat tree_ul_from_hash(category[:children],false, &block) if category[:children].present?
       end
      end
    res << "</ul>\n"
    raw res  
  end  
end
