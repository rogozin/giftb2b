#encoding: utf-8;
module Admin::ProductsHelper
  def color_stroe_count(cnt)
  if cnt > 0 
    "<span style='color:blue;font-weight:bold'>#{cnt}</span>"
  else 
    "0"
   end 
  end

  def has_selected_items?(property, selected_items)
    property.property_values.where(:id => selected_items).present?
  end 
  
  def has_selected_items_class(property, selected_items)
    has_selected_items?(property,selected_items) ? "has-selected-items" : ""
  end
end
