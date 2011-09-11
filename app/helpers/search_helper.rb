#encoding: utf-8;
module SearchHelper
  
  def prop_name obj, array = false
    res  =  "pv_#{obj.id}"
    res << "[]" if array
    res
  end
end
