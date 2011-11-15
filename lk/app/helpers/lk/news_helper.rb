#encoding: utf-8;
module Lk::NewsHelper

  def main_menu_item(title, link)
    content_tag(:p, link_to(title, link), :class => link.match(action_name) ? "selected" : nil)
  end
  
end
