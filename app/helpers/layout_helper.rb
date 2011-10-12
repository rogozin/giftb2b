#encoding: utf-8;
    # These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper


  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end

  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) }
  end
  
#  def link_to_this_page(controller, action, id)
#    l = url_for(:only_path => false, :controller => controller, :action => action, :id => id )
#    link_to(l,l);
#  end
end 
