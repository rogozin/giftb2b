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
  record.after_create { |user| add_role(user,:role_user) }  
end

Factory.define :admin, :class => User, :parent => :user do |record|    
  record.username "administrator"
  record.email "admin@whatever.com"
  record.role_objects {|role|  [role.association(:role_admin)]}
end

Factory.define :catalog_editor, :class => User, :parent => :user do |record|    
  record.role_objects {|role|  [role.association(:role_catalog_editor)]}
end

Factory.define :firm_manager, :class => User, :parent => :user do |record|    
  record.role_objects {|role|  [role.association(:role_firm_manager)]}
end

Factory.define :sample_manager, :class => User, :parent => :user do |record|    
  record.after_create { |user| add_role(user,:role_samples) }
end

Factory.define :content_editor, :parent => :catalog_editor, :class => User do |record|    
  record.role_objects {|role|  [role.association(:role_content_editor)]}
end

def add_role(user, factory_name)
 r = Factory.build(factory_name)
 #Factory(factory_name) unless Role.where(:name => r.name).exists?
 user.has_role!(r.name)
 Role.update_all("roles.group = #{r.group}", ["name=:name", :name => r.name] )
end

Factory.define :role_admin, :class => Role do |f|
  f.name "Администратор"
  f.group 0
end

Factory.define :role_catalog_editor, :class => Role do |f|
  f.name "Редактор каталога"
  f.group 0
end

Factory.define :role_content_editor, :class => Role do |f|
  f.name "Редактор контента"
  f.group 0
end

Factory.define :role_samples, :class => Role do |f|
  f.name "Учет образцов"
  f.group 0
end

Factory.define :role_user, :class => Role do |f|
  f.name "Пользователь"
  f.group 1
end

Factory.define :role_firm_manager, :class => Role do |f|
  f.name "Менеджер фирмы"
  f.group 2
end

Factory.define :role_firm_user, :class => Role do |f|
  f.name "Пользователь фирмы"
  f.group 2
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
  f.subway "Текстильщики"
  f.show_on_site true
  f.after_create { |firm| firm.update_attribute :short_name, firm.name   }  
end

