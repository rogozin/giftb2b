#encoding: utf-8;
module Admin::PropertiesHelper

def prop_list_for_categories(category_ids)
  props= Property.find(:all, :joins=>:property_category, :select => "distinct properties.*", :conditions=> ["property_categories.category_id in (?)",category_ids])
  ret=""
  for prop in props
    ret += prop.name + "<br />"
  end
  raw ret
end

end
