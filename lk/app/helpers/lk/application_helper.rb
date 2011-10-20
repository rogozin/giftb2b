#encoding: utf-8;
module Lk
  module ApplicationHelper
         
  def firm_logo_present?
    current_user && current_user.firm && current_user.firm.images.present?
  end
  
  def render_lk_menu
    res = ""
    res << content_tag(:p, link_to('Список заказов', orders_path, :class => "menu_left"))  if  current_user.is_lk_user?
  	res << content_tag(:p, link_to('Коммерческие предложения', commercial_offers_path, :class => "menu_left")) if current_user.is_firm_user?
    res << content_tag(:p, link_to('Клиенты', firms_path, :class => "menu_left")) if  current_user.is_lk_user?
    res << content_tag(:p, link_to('Мой список товаров', products_path, :class => "menu_left")) if  current_user.is_lk_user?
    res << content_tag(:p, link_to('Образцы', samples_path, :class => "menu_left"))  if current_user.has_role?(:Администратор) || current_user.has_role?("Учет образцов")
    res << content_tag(:p, link_to('Пользователи', accounts_path, :class => "menu_left")) if  current_user.is_firm_manager?
    res << content_tag(:div, nil, :class => "line")
    res << content_tag(:p, link_to('На главную страницу', main_app.root_path, :class => "menu_left"))
    raw res
  end


  def help_popup text
    content_tag :span, :class => "i-help-popup" do
      concat image_tag("pix.gif")
      concat content_tag(:div, simple_format(text), :class => "b-info-popup")      
    end    
  end
  end
end
