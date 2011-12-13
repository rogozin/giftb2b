#encoding: utf-8;
module Lk::ApplicationHelper
         
  def firm_logo_present?
    current_user && current_user.firm && current_user.firm.images.present?
  end
  
  def render_lk_menu
    res = ""    
    res << lk_menu_item('Поступившие заказы', orders_path)  if  current_user.is_lk_user?
    res << lk_menu_item('Клиенты', firms_path) if  current_user.is_lk_user?
  	res << lk_menu_item('Коммерческие предложения', commercial_offers_path) if current_user.is_firm_user?
    res << lk_menu_item('Моя база сувениров', products_path) if  current_user.is_lk_user?
    res << lk_menu_item('Мои новости', news_index_path) if  current_user.is_firm_user?
    res << lk_menu_item('Образцы', samples_path)  if current_user.has_role?(:Администратор) || current_user.is_firm_user?
    res << lk_menu_item('Пользователи', accounts_path, "l-users") if  current_user.is_firm_manager?
    raw res
  end
  
  def lk_menu_item(title, link, class_name="l-folder")
    content_tag(:p, link_to(title, link, :class => class_name), :class => selected_class = link.match(controller_name) ? "selected" : nil )
  end
end
