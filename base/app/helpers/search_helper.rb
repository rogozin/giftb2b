#encoding: utf-8;
module SearchHelper
  
  def prop_name obj, array = false
    res  =  "pv_#{obj.id}"
    res << "[]" if array
    res
  end
  
  def prop_values_tree(property, selected=[], options={})
    options[:class] ||= dom_class(property)
    options[:grouped] ||= false
    options[:field_name] ||= "pv_#{property.id}"
    res = ""
    if options[:grouped]
      property.property_values.group_by(&:group_order).each do |group_order, values|
       res <<  build_property_values_list(values, "#{options[:class]} property_#{group_order}", options[:field_name], selected)
      end
    else
      res << build_property_values_list(property.property_values, options[:class], options[:field_name], selected)
    end
    raw res
  end  

  private

  def build_property_values_list(values, class_name, field_name, selected=[]) 
     content_tag(:ul, :class => class_name) do
      values.each do |item|
       concat content_tag(:li, check_box_tag(field_name + "[]", item.id, selected.include?(item.id.to_s), :id => dom_id(item)) + label_tag(dom_id(item), item.value) )
      end        
    end
  end

end
