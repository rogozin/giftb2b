#encoding:utf-8;
class MoveRolesToServices < ActiveRecord::Migration
  def up   
    say "upading existed roles"
    r_admin = Role.find_by_name("Администратор")
    r_admin.update_attributes(:name => "admin", :description => "Полный администратор", :group => 0)                
    
    r_a_ca = Role.find_by_name("Редактор каталога")
    r_a_ca.update_attributes(:name => "admin_catalog", :description => "Админка, каталог", :group => 0)                    
    r_a_co =Role.find_by_name("Редактор контента")
    r_a_co.update_attributes(:name => "admin_content", :description => "Админка, контент", :group => 0)                    
    r_a_us = Role.create(:name => "admin_users", :description => "Админка, пользователи", :group => 0)                    
    say "creating new roles"    
    r_ca = Role.create(:name => "catalog", :description => "Доступ к каталогу", :group => 2)    
    r_s = Role.create(:name => "ext_search", :description => "Доступ к поиску", :group => 2)
    r_co = Role.create(:name => "lk_co", :description => "Доступ к коммерческому предложению", :group => 2)
    r_logo = Role.create(:name => "lk_logo", :description => "Доступ к нанесению логотипа", :group => 2)
    r_c = Role.create(:name => "lk_clients", :description => "Доступ к клиентам", :group => 2)    
    r_samp = Role.create(:name => "lk_samples", :description => "Доступ к образцам", :group => 2)    
    r_p = Role.create(:name => "lk_products", :description => "Доступ к моим товарам", :group => 2)    

    
        
    r_su = Role.find_by_name("Пользователь")
    r_su.update_attributes(:name => "simple_user", :description => "Доступ к личному кабинету конечника", :group => 3) if r_su
        
        
    say "create services"    
    s_s = Service.create(:name => "База данных с расширенным поиском", :roles => [r_s, r_ca])
    s_s10 = Service.create(:name => "Набор поставщиков (минимум)")
    s_s20 = Service.create(:name => "Набор поставщиков (средний)")
    s_s30 = Service.create(:name => "Набор поставщиков (максимум)")
    s_co = Service.create(:name => "Коммерческое предложение", :roles => [r_co]) 
    s_co_logo = Service.create(:name => "Коммерческое предложение + Лого", :roles => [r_co, r_logo]) 
    s_sс = Service.create(:name => "Образцы + клиенты", :roles => [r_samp, r_c])     
    s_mp = Service.create(:name => "Мои товары", :roles => [r_p])   
    
    say "add supplier to roles", true
    Supplier.all.each do |sup|
      s_s30.roles.create(:name => sup.name, :description => sup.name, :group => 5, :authorizable_id => sup.id, :authorizable_type => "Supplier")
    end   
    
    firm_manager = Role.find_by_name("Менеджер фирмы")
    
    
    say "update users access rights and add services to firms"
    User.joins(:role_objects).where("roles.id=?", firm_manager.id).each do |user|
      [s_s, s_s30, s_co_logo, s_sс, s_mp].each{|ss| user.firm.commit_service(ss) if user.firm && user.active?}
    end

    firm_manager.upadte_attributes(:name => "lk_users", :description => "Доступ к упралению пользователями", :group => 2)    
             
  end

  def down
  end
end
