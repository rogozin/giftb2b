#encoding: utf-8;
module LkHelper
  def render_lk_menu
    res = ""
    res << content_tag(:p, link_to('Список заказов', lk_user_orders_path, :class => "menu_left")) if current_user.is_simple_user?
    if current_user.is_admin_user? || current_user.is_firm_user?
      res << content_tag(:p, link_to('Список заказов', lk_orders_path, :class => "menu_left")) 
    	res << content_tag(:p, link_to('Коммерческие предложения', lk_commercial_offers_path, :class => "menu_left"))
      res << content_tag(:p, link_to('Клиенты', lk_firms_path, :class => "menu_left"))
      res << content_tag(:p, link_to('Список товаров', lk_products_path, :class => "menu_left"))
      res << content_tag(:p, link_to('Образцы', lk_samples_path, :class => "menu_left"))  if current_user.has_role?(:Администратор) || current_user.has_role?("Учет образцов")
    end
    res << content_tag(:p, link_to('Пользователи', lk_accounts_path, :class => "menu_left")) if current_user.is_admin_user? || current_user.is_firm_manager?
    res << content_tag(:p, link_to('Профиль', profile_path, :class => "menu_left"))
    #res << content_tag(:p, link_to("Подписки", "",:class => "menu_left"))
    raw res
  end


  def help_popup text
    content_tag :span, :class => "i-help-popup" do
      concat image_tag("pix.gif")
      concat content_tag(:div, simple_format(text), :class => "b-info-popup")      
    end    
  end
  
end
