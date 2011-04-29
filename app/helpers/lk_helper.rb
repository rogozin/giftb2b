module LkHelper
  def render_lk_menu
    res = ""
    res << content_tag(:p, link_to('Мои заказы', lk_user_orders_path, :class => "menu_left")) if current_user.is_simple_user?
    if current_user.is_admin_user? || current_user.is_firm_user?
      res << content_tag(:p, link_to('Список заказов', lk_orders_path, :class => "menu_left")) 
    	res << content_tag(:p, link_to('Коммерческие предложения', lk_commercial_offers_path, :class => "menu_left"))
      res << content_tag(:p, link_to('Мои фирмы', lk_firms_path, :class => "menu_left"))
      res << content_tag(:p, link_to('Мои товары', lk_products_path, :class => "menu_left"))
    end
    res << content_tag(:p, link_to('Пользователи', lk_accounts_path, :class => "menu_left")) if current_user.is_admin_user? || current_user.is_firm_manager?
    res << content_tag(:p, link_to('Мой профиль', profile_path, :class => "menu_left"))
    res << content_tag(:p, link_to("Подписки", "",:class => "menu_left"))
    raw res
  end
  
end
