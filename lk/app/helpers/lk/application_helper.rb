#encoding: utf-8;
module Lk
  module ApplicationHelper
         
  def firm_logo_present?
    current_user && current_user.firm && current_user.firm.images.present?
  end
  
  def render_lk_menu
    res = ""    
    res << lk_menu_item('Список заказов', orders_path)  if  current_user.is_lk_user?
  	res << lk_menu_item('Коммерческие предложения', commercial_offers_path) if current_user.is_firm_user?
    res << lk_menu_item('Клиенты', firms_path) if  current_user.is_lk_user?
    res << lk_menu_item('Мой список товаров', products_path) if  current_user.is_lk_user?
    res << lk_menu_item('Мои новости', news_index_path) if  current_user.is_firm_user?
    res << lk_menu_item('Образцы', samples_path)  if current_user.has_role?(:Администратор) || current_user.is_firm_user?
    res << lk_menu_item('Пользователи', accounts_path) if  current_user.is_firm_manager?
    res << content_tag(:div, nil, :class => "line")
    res << lk_menu_item('На главную страницу', main_app.root_path)
    raw res
  end
  
  def lk_menu_item(title, link)
    selected_class = link.match(controller_name) ? "lk-menu-item selected" : "lk-menu-item"
    content_tag(:p, link_to(title, link), :class => selected_class)
  end
  
  def selected_menu_class

  end


  def help_popup text
    content_tag :span, :class => "i-help-popup" do
      concat image_tag("pix.gif")
      concat content_tag(:div, simple_format(text), :class => "b-info-popup")      
    end    
  end
  end
end
