#encoding: utf-8;
module Lk
  module ApplicationHelper
         
  def firm_logo_present?
    current_user && current_user.firm && current_user.firm.images.present?
  end
  
  def render_lk_menu
    res = ""
    if current_user.is_admin_user? || current_user.is_firm_user?
      res << content_tag(:p, link_to('Список заказов', orders_path, :class => "menu_left")) 
    	res << content_tag(:p, link_to('Коммерческие предложения', commercial_offers_path, :class => "menu_left"))
      res << content_tag(:p, link_to('Клиенты', firms_path, :class => "menu_left"))
      res << content_tag(:p, link_to('Список товаров', products_path, :class => "menu_left"))
      res << content_tag(:p, link_to('Образцы', samples_path, :class => "menu_left"))  if current_user.has_role?(:Администратор) || current_user.has_role?("Учет образцов")
    end
    res << content_tag(:p, link_to('Пользователи', accounts_path, :class => "menu_left")) if current_user.is_admin_user? || current_user.is_firm_manager?
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
