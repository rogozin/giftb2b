# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def  checked_box_image(checked=false,id='')
    id.blank?  ?  image_tag(checked ? 'checked.gif' : 'unchecked.gif') :  image_tag(checked ? 'checked.gif' : 'unchecked.gif', :id=>id) 
  end
  

end

