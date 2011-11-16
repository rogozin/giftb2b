#encoding: utf-8;
module Lk::NewsHelper

  def main_menu_item(title, link, state_ids=[])
    
    content_tag(:p , :class => link.ends_with?(action_name) ? "selected" : nil) do
      concat link_to(title, link) 
      r =""
      r << state_ids.map{|x|  content_tag(:span, news_cnt(x), :class => "state_#{x}" )}.join("/")
      concat raw(r)
    end
  end
  
  def news_cnt(status)
    News.where(:firm_id => current_user.firm_id, :state_id => status).count
  end
  
end
