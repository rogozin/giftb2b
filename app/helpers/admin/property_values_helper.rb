#encoding: utf-8;
module Admin::PropertyValuesHelper
  
  def prop_values_tree(property, options={})
    options[:class] ||= dom_class(property)
    options[:grouped] ||= false
    
    content_tag(:ul, :class => options[:class]) do
      property.property_values.each do |item|
       concat content_tag(:li, item.value)
      end        
    end
  end  
end
