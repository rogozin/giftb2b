#encoding: utf-8;
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def  checked_box_image(checked=false,id=nil)
      image_tag(checked ? 'checked.gif' : 'unchecked.gif', :id=>id) 
  end
  
  def mark_required(object, attribute)  
    "*" if object.class.validators_on(attribute).map(&:class).include? ActiveModel::Validations::PresenceValidator  
  end  

  
end

