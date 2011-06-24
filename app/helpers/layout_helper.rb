#encoding: utf-8;
    # These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, show_title = true)    
    @content_for_title = page_title.to_s
    @show_title = show_title
  end

  def page_title(header=nil)
    default = "giftb2b.ru" 
    @page_title = [header, default].compact.join(' | ')
  end
  
  def show_title?
    @show_title
  end

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
