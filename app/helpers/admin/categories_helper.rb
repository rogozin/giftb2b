module Admin::CategoriesHelper
 def category_tree_table(acts_as_tree_set, init=true,level=0, &block)
   @cached_categories = Category.cached_all_categories
    if acts_as_tree_set.size > 0
      ret =""
      if init
        ret += "<table id='tree_table'>" 
        ret += "<tr><th>-</th> <th>Имя</th><th>Активен?</th><th>Сорт</th><th>Тип</th><th></th><th></th></tr>"
      end 
      level+=1
      acts_as_tree_set.collect do |item|
        next if item.parent_id && init
        ret += "<tr>"
        ret+= content_tag('td',link_to(image_tag('edit.png'),edit_admin_category_path(item) ))     
        ret +=  content_tag("td style='padding-left:#{level*10}px'") do
         init ?  raw( "<strong>#{item.name}</strong>")  : item.name
        end
        ret += content_tag('td',link_to(checked_box_image(item.active?), {:action=>"toggle_state",:id=>item.id}, :remote => true), :class=>"center")                               
        ret += "<td>"
        ret += text_field_tag("cat_sort_#{item.id}",item.sort_order, :size =>2) 
           ret += link_to image_tag('disk.png'), {:action => "change_sort", :id=>item.id }, :remote => true, 
           :onclick => " $(this).attr('href',$(this).attr('href')+'?sort='+$('#cat_sort_#{item.id}').attr('value'))", :complete => "$('#cat_sort_#{item.id}').parents('tr').effect('highlight',{},2000)"          
        ret += "</td>"  
        ret+= content_tag('td', item.parent_id ? "" : item.kind_name)          
        ret+= content_tag('td',tree_destroy_item_link(item))                
        ret+= content_tag('td', tree_new_sub_category_link(item))
        ret += "</tr>\n"        
        children=@cached_categories.select {|set_item| set_item.parent_id==item.id}
        ret += category_tree_table(children, false,level, &block) if children.size > 0

      end
      ret += '</table>' if init
    end  
    raw ret  
  end
  
  def tree_ul_category(acts_as_tree_set, child = nil, init=true,field_name='property',category_ids=[])
    if init 
      roots = acts_as_tree_set.select{|set_item| set_item.parent_id==nil}    
    else
      roots = child
    end   
    if roots.size > 0
      
      ret = init ?  "<ul#{" id='tree_listr'" if init}> \n" : "<ul id='child_list_#{roots.first.parent_id}' style='display:none;' > \n"
      roots.collect do |item|
        #next if item.parent_id && init
        ret += '<li>'
        children=acts_as_tree_set.select {|set_item| set_item.parent_id==item.id}
        ret += check_box_tag "#{field_name}[category_ids][]",item.id, (category_ids.include?  item.id)
        unless children.empty?
          ret += "<a href=\"javascript:void($('#child_list_#{item.id}').toggle());\" class='pseudo-link'>#{item.name }</a>"
        else
          ret += item.name 
        end
        ret += tree_ul_category(acts_as_tree_set,children, false, field_name, category_ids) if children.size > 0
        ret += "</li> \n"
      end
      ret += "</ul> \n"      
     ret += hidden_field_tag("#{field_name}[category_ids][]", '' )
    end
    raw ret
  end
  
  private
  def tree_destroy_item_link item
    ret = "["
    ret +=  link_to "x", admin_category_path(item.id), :remote => true, :method => :delete, :confirm => 'Удалить категорию?'
    ret += "]"
    raw ret
  end
  
  def tree_new_sub_category_link item
    ret = "["
    ret += link_to("+", new_admin_category_path(:parent_id=>item.id), :title=>"Новая подкатегория для '#{item.name}'" )
    ret += "]"
    raw ret
  end

end
