#encoding: utf-8;
module Lk::ApplicationHelper
         
  def firm_logo_present?
    current_user && current_user.firm && current_user.firm.images.present?
  end
  
  def render_lk_menu
    res = ""    
    res << lk_menu_item("Поступившие заказы", lk_engine.orders_path)  if current_user.has_role?(:lk_order)
    res << lk_menu_item('Клиенты', lk_engine.firms_path) if current_user.has_role?(:lk_client)
  	res << lk_menu_item('Коммерческие предложения', lk_engine.commercial_offers_path) if current_user.has_role?(:lk_co)
    res << lk_menu_item('Моя база сувениров', lk_engine.products_path) if current_user.has_role?(:lk_product)
    res << lk_menu_item('Мои новости', lk_engine.news_index_path) if current_user.has_role?(:lk_news)
    res << lk_menu_item('Образцы', lk_engine.samples_path)  if current_user.has_role?(:lk_sample)
    res << lk_menu_item('Профиль компании', lk_engine.profile_path, "l-users") if current_user.has_role?(:lk_supplier)
    res << lk_menu_item('Пользователи', lk_engine.accounts_path, "l-users") if  current_user.is_firm_manager?
    raw res
  end
  
  def lk_menu_item(title, link, class_name="l-folder")
    content_tag(:p, link_to(title, link, :class => class_name), :class => selected_class = link.match(controller_name) && controller.class.parent_name == "Lk" ? "selected" : nil )
  end
end
