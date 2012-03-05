#encoding: utf-8;
module Lk::ApplicationHelper
  
  def submit_action form
   form.actions do
     submit_tag "Сохранить",  :class => "btn btn-primary"
    end 
  end
         
  def firm_logo_present?
    current_user && current_user.firm && current_user.firm.images.present?
  end
  
  def render_static_navbar_menu        
    content_tag :ul, :class => "nav" do
      concat navbar_item("Заказы", lk_engine.orders_path) 
      concat navbar_item("Клиенты", lk_engine.firms_path) 
      concat navbar_item("Коммерческие предложения", lk_engine.commercial_offers_path) 
      concat navbar_item("Мои сувениры", lk_engine.products_path)
      concat navbar_item("Образцы", lk_engine.samples_path)  
      concat navbar_item("Новости компании", lk_engine.news_index_path)
    end      
  end


  def render_navbar_menu        
    content_tag :ul, :class => "nav" do
      concat navbar_item("Заказы", lk_engine.orders_path) if current_user.is?(:lk_order)
      concat navbar_item("Клиенты", lk_engine.firms_path) if current_user.is?(:lk_client)
      concat navbar_item("Коммерческие предложения", lk_engine.commercial_offers_path) if current_user.is?(:lk_co)
      concat navbar_item("Мои сувениры", lk_engine.products_path) if current_user.is?(:lk_product)
      concat navbar_item("Образцы", lk_engine.samples_path)  if current_user.is?(:lk_sample)
      concat navbar_item("Новости компании", lk_engine.news_index_path) if current_user.is?(:lk_news)
    end      
  end

  def render_user_menu
    content_tag :ul, :class => "dropdown-menu" do
      concat content_tag :li, link_to("Настройки аккаунта", auth_engine.profile_path)
      concat content_tag :li, link_to("Пользователи", lk_engine.accounts_path) if  current_user.is_firm_manager?
      concat content_tag :li, link_to("Профиль компании", lk_engine.profile_path) if current_user.is?(:lk_supplier)
      concat content_tag :li, "", :class => "divider"
      concat content_tag :li, link_to("Выход", auth_engine.destroy_user_session_path, :method => :delete)      
    end
  end
 
  def navbar_item title, link
    content_tag :li, link_to(title, link), :class => link.match(controller_name) && controller.class.parent_name == "Lk" ? "active" : nil
  end
  
  
  def is_lk?
    controller.class.parent_name == "Lk"
  end

end
