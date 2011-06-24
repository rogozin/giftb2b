#encoding: utf-8;
module Admin::ProductsHelper
  def color_stroe_count(cnt)
  if cnt > 0 
    "<span style='color:blue;font-weight:bold'>#{cnt}</span>"
  else 
    "0"
   end 
  end

  def product_properties_tree(category_ids,property_value_ids=[])
    props= Property.find(:all, :joins => :property_category, :conditions=>["property_categories.category_id in (?)",category_ids ],:select => "distinct properties.*")
    html =""
    return html unless props
    html += "<ul id='tree_list'>"
    for property in props do
      html += "<li>\n"
      html += "<a href=\"javascript:void($('#prop_child_list_#{property.id}').toggle());\" class='pseudo-link'>#{property.name }</a>\n"
      if property.property_values
        html += "<ul id='prop_child_list_#{property.id}' style='display:none;'>"
         for pv in property.property_values
           html += "<li>"
           html += check_box_tag "product[property_value_ids][]",pv.id, (property_value_ids.include?  pv.id)         
           html += pv.value
           html += "</li>"
         end
        html += "</ul>"
      end   
      html += "</li>\n"
    end
    html +="</ul>"
    raw html
  end
end
