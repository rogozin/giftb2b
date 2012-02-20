#encoding: utf-8;
Factory.sequence :user_seq do |n|
  "User_#{n}"
end

Factory.define :user, :class => User do |record|    
  record.username { Factory.next(:user_seq) }
  record.email {"#{Factory.next(:user_seq)}@email.com"}
  record.password "user"
  record.password_confirmation {|p| p.password }
  record.active true
  record.fio "Василий"
  record.company_name "Рога и Копытца"
  record.city "Москва"
  record.phone "+7 (495) 888-23-34"
  #record.role_objects {|role|  [role.association(:role_user)]}
end


Factory.define :simple_user, :class =>User, :parent => :user do |record|
  record.after_create { |user| add_role(user,:role_user) }    
end

Factory.define :admin, :class => User, :parent => :user do |record|    
  record.username "administrator"
  record.email "admin@whatever.com"
  record.role_objects {|role|  [role.association(:role_admin)]}
end

Factory.define :catalog_editor, :class => User, :parent => :user do |record|    
  record.role_objects {|role|  [role.association(:role_catalog_editor) ]}
end

Factory.define :firm_manager, :class => User, :parent => :user do |record|    
  record.firm_id 1
  record.role_objects {|role|  [role.association(:r_search),
  role.association(:r_catalog),  role.association(:r_logo),  role.association(:r_co),
  role.association(:r_clients), role.association(:r_products), role.association(:r_samples),
  role.association(:r_news),   role.association(:r_orders), role.association(:r_admin), role.association(:r_supplier)]}
end

Factory.define :firm_user, :class => User, :parent => :user do |record|    
  record.firm_id 1
  record.role_objects {|role|  [role.association(:r_search),
  role.association(:r_catalog),  role.association(:r_logo),  role.association(:r_co),
  role.association(:r_clients), role.association(:r_products), role.association(:r_samples),
  role.association(:r_news),   role.association(:r_orders), role.association(:r_supplier)]}
end

Factory.define :supplier_manager, :class => User, :parent => :user do |record|    
  record.association :firm
  record.association :supplier
  record.role_objects {|role|  [
  role.association(:r_news),   role.association(:lk_supplier)]}
#  record.after_create { |user| add_role(user,:role_user) }      
end

Factory.define :content_editor, :parent => :catalog_editor, :class => User do |record|    
  record.role_objects {|role|  [role.association(:role_content_editor)]}
end

Factory.define :web_store_manager, :class => User, :parent => :user do |record|    
  record.after_create { |user| add_role(user, :web_store) }
end

Factory.define :first_manager, :class => User, :parent => :user do |record|    
  record.after_create { |user| add_role(user, :first_manager_role) }
end

Factory.define :second_manager, :class => User, :parent => :user do |record|    
  record.after_create { |user| add_role(user, :second_manager_role) }
end

def add_role(user, factory_name)
 r = Factory.build(factory_name)
 #Factory(factory_name) unless Role.where(:name => r.name).exists?
 user.has_role!(r.name)
 Role.update_all("roles.group = #{r.group}", ["name=:name", :name => r.name] )
end

Factory.define :role_admin, :class => Role do |f|
  f.name "admin"
  f.group 0
end

Factory.define :role_catalog_editor, :class => Role do |f|
  f.name "admin_catalog"
  f.group 0
end

Factory.define :role_content_editor, :class => Role do |f|
  f.name "admin_content"
  f.group 0
end

Factory.define :first_manager_role, :class => Role do |f|
  f.name "Главный менеджер"
  f.group 0
end

Factory.define :second_manager_role, :class => Role do |f|
  f.name "Менеджер продаж"
  f.group 0
end

Factory.define :role_user, :class => Role do |f|
  f.name "simple_user"
  f.group 3
end


Factory.sequence :firm_seq do |n|
   "ООО Рога и копыта, клон #{n}"
  end
  

Factory.define :firm do |f|
  f.name {Factory.next(:firm_seq)}
  f.email "firm@example.com"
  f.url "http://www.example.com"
  f.addr_f "Москва, ул. Льва Толстого д.12 стр. 1"
  f.addr_u "Москва, хата с краю"
  f.city "Москва"
  f.phone "+7(495)123-4567"
  f.subway "Текстильщики"
  f.show_on_site true
  f.after_create { |firm| firm.update_attribute :short_name, firm.name   }  
end


Factory.define :service do |f|
  f.name "услуга"
  f.code "serv"  
end

Factory.define( :r_catalog, :class => Role) do |f|
  f.name "catalog"
  f.description "Доступ к каталогу"
  f.group  2
end
Factory.define(:r_search, :class => Role) do |f|
  f.name "ext_search"
  f.description "Доступ к поиску"
  f.group  2
end
Factory.define(:r_co, :class => Role) do |f|
  f.name "lk_co"
  f.description "Доступ к коммерческому предложению"
  f.group  2
end
Factory.define(:r_logo, :class => Role) do |f|
  f.name "lk_logo"
  f.description "Доступ к нанесению логотипа"
  f.group  2
end
Factory.define(:r_clients, :class => Role) do |f|
  f.name "lk_client"
  f.description "Доступ к клиентам"
  f.group  2
end
Factory.define(:r_samples, :class => Role) do |f|
  f.name "lk_sample"
  f.description "Доступ к образцам"
  f.group  2
end
Factory.define(:r_products, :class => Role) do |f|
  f.name "lk_product"  
  f.description "Доступ к моим товарам"
  f.group  2
end
Factory.define(:r_news, :class => Role) do |f|
  f.name "lk_news"
  f.description "Доступ к новостям"
  f.group  2
end
Factory.define(:r_orders, :class => Role) do |f|
  f.name "lk_order"
  f.description "Доступ к заказам"
  f.group  2
end
Factory.define(:r_supplier, :class => Role) do |f|
  f.name "supplier_viewer"
  f.description "Доступ к странице поставщика"
  f.group  2
end
Factory.define(:r_admin, :class => Role) do |f|
  f.name "lk_admin"
  f.description "Доступ к управлению пользователей"
  f.group  2
end

Factory.define(:lk_supplier, :class => Role) do |f|
  f.name "lk_supplier"
  f.description "Личный кабинет поставщика"
  f.group  6
end

Factory.define :all_inclusive, :class =>  :service do |f|
  f.name "Все включено"
  f.code "all_inclusive"
  f.roles { [Factory(:r_orders), Factory(:r_samples), Factory(:r_catalog), Factory(:r_logo), 
             Factory(:r_search), Factory(:r_co), Factory(:r_clients), Factory(:r_products)]}
end
  
