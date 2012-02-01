#encoding:utf-8;
class MoveRolesToServices < ActiveRecord::Migration
  def up   
    if Rails.env != "test"
      say "upading existed roles"
      r_admin = Role.find_by_name("Администратор")
      r_admin.update_attributes(:name => "admin", :description => "Полный администратор", :group => 0)  if r_admin
      
      r_a_ca = Role.find_by_name("Редактор каталога")
      r_a_ca.update_attributes(:name => "admin_catalog", :description => "Админка, каталог", :group => 0) if r_a_ca           
      r_a_co =Role.find_by_name("Редактор контента")
      r_a_co.update_attributes(:name => "admin_content", :description => "Админка, контент", :group => 0) if r_a_co
      r_a_us = Role.create(:name => "admin_user", :description => "Админка, пользователи", :group => 0)                    
      say "creating new roles"    
      r_ca = Role.create(:name => "catalog", :description => "Доступ к каталогу", :group => 2)    
      r_s = Role.create(:name => "ext_search", :description => "Доступ к поиску", :group => 2)
      r_co = Role.create(:name => "lk_co", :description => "Доступ к коммерческому предложению", :group => 2)
      r_logo = Role.create(:name => "lk_logo", :description => "Доступ к нанесению логотипа", :group => 2)
      r_c = Role.create(:name => "lk_client", :description => "Доступ к клиентам", :group => 2)    
      r_samp = Role.create(:name => "lk_sample", :description => "Доступ к образцам", :group => 2)    
      r_p = Role.create(:name => "lk_product", :description => "Доступ к моим товарам", :group => 2)    
      r_news = Role.create(:name => "lk_news", :description => "Доступ к новостям", :group => 2)        
      r_orders = Role.create(:name => "lk_order", :description => "Доступ к заказам", :group => 2)            

      r_sup = Role.create(:name => "supplier_viewer", :description => "Доступ к странице поставщика", :group => 2)    
                
      r_su = Role.find_by_name("Пользователь")
      r_su.update_attributes(:name => "simple_user", :description => "Доступ к личному кабинету конечника", :group => 3) if r_su
          
      say "create services"    
      s_s = Service.create(:name => "База данных с расширенным поиском", :code=> "base_ext_search", :roles => [r_s, r_ca, r_sup, r_news, r_orders])
      s_s10 = Service.create(:name => "Набор поставщиков (минимум)", :code => "sup_min")
      s_s20 = Service.create(:name => "Набор поставщиков (средний)", :code => "sup_med")
      s_s30 = Service.create(:name => "Набор поставщиков (максимум)", :code => "sup_max")
      s_co = Service.create(:name => "Коммерческое предложение", :code => "co", :roles => [r_co, r_sup, r_news, r_orders]) 
      s_co_logo = Service.create(:name => "Коммерческое предложение + Лого", :code => "co_logo", :roles => [r_co, r_logo, r_sup, r_news, r_orders]) 
      s_sc = Service.create(:name => "Образцы + клиенты", :code => "s_cli", :roles => [r_samp, r_c, r_sup, r_news, r_orders])     
      s_mp = Service.create(:name => "Мои товары", :code => "my_goods", :roles => [r_p, r_sup, r_news, r_orders])   
      
      say "add supplier to roles", true
      Supplier.all.each do |sup|
        s_s30.roles.create(:name => sup.name, :description => sup.name, :group => 5, :authorizable_id => sup.id, :authorizable_type => "Supplier")
      end   
      
      firm_manager = Role.find_by_name("Менеджер фирмы")
      
      say "update users access rights and add services to firms"
      User.joins(:role_objects).where("roles.id=?", firm_manager.id).each do |user|      
        [s_s, s_s30, s_co_logo, s_sc, s_mp].each{|ss| user.firm.services << ss if user.firm && user.active?}
      end

      firm_manager.update_attributes(:name => "lk_admin", :description => "Доступ к упралению пользователями", :group => 2)    
    end          
  end

  def down
  end
end
