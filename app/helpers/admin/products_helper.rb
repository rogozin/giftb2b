#encoding: utf-8;
module Admin::ProductsHelper
  def color_stroe_count(cnt)
  if cnt > 0 
    "<span style='color:blue;font-weight:bold'>#{cnt}</span>"
  else 
    "0"
   end 
  end

  def get_prop_values(product, property_id)
    product.property_values.where(:property_id => property_id).map(&:value).join(', ')
  end

  def has_selected_items?(property, selected_items)
    property.property_values.where(:id => selected_items).present?
  end 
  
  def has_selected_items_class(property, selected_items)
    has_selected_items?(property,selected_items) ? "has-selected-items" : ""
  end
  
  def build_field_settings
    res = ""
    index = 0
    product_fields.each do |key,val|
      res << "<div class='float-fields'>" if (index % 5).zero?
      res << "<div>\n"
      res << check_box_tag("fields_settings[]", key,  product_fields_session && product_fields_session[key]    , :id => "field_#{key.to_s}")
      res << label_tag("field_#{key.to_s}", val)
      res << "</div>\n"
      res << "</div>" if ((index +1) % 5).zero? || product_fields.keys.size == (index + 1)
      index +=1
    end
   raw res 
  end
  
  def build_table_headers
    res = ""
    product_fields_session.select{|k,v| v}.each do |key,value|
      res << "<th>#{product_fields[key]}</th>\n"
    end
    raw res
  end
  
  def build_editable_cell_link(product_id, property_id)
     content_tag(:div, link_to('изменить', inline_property_values_admin_product_path(product_id, :property_id => property_id), :remote => true, :class => "pseudo-link" ), :class => "inline-property" ) 
  end
  
  def build_cell field_name, value, options={}
    res = ""
    id = nil
    if field_name =~ /property_/ && options.has_key?(:product_id) && options.has_key?(:property_id)
      id = "product_#{options[:product_id]}_property_#{options[:property_id]}" 
      value += build_editable_cell_link(options[:product_id], options[:property_id])
    end
    res << content_tag(:td, raw(value), :class => options[:class].present? ? options[:class] : nil, :id => id )     if product_fields_session && product_fields_session[field_name] == true
    raw res      
  end
  

  
  def build_properties_cell(product)
    res = ""
    product_fields_session.select{|k,v| k.to_s =~ /property_/ }.each do |key, value|
      property_id = key.to_s.match(/\d+/)
      res << build_cell(key, get_prop_values(product, property_id.to_s), {:product_id => product.id, :property_id => property_id})
    end         
    raw res 
  end
  
end
