#encoding: utf-8;
Factory.define :user, :class => User do |record|    
  record.username "user"
  record.email "user@whatever.com"
  record.password "user"
  record.password_confirmation {|p| p.password }
  record.active true
  record.role_objects {|role|  [role.association(:role_user)]}
end

Factory.define :admin, :class => User, :parent => :user do |record|    
  record.username "administrator"
  record.email "admin@whatever.com"
  record.role_objects {|role|  [role.association(:role_admin)]}
end

Factory.define :catalog_editor, :class => User, :parent => :user do |record|    
  record.username "editor"
  record.email "editor@whatever.com"
  record.role_objects {|role|  [role.association(:role_catalog_editor)]}
end

Factory.define :firm_manager, :class => User, :parent => :user do |record|    
  record.username "firm_manager"
  record.email "firm_manager@whatever.com"
  record.role_objects {|role|  [role.association(:role_firm_manager)]}
end

Factory.define :sample_manager, :class => User, :parent => :user do |record|    
  record.username "sampler"
  record.email "user@whatever.com"
  record.role_objects {|role|  [role.association(:role_samples)]}
end

Factory.define :content_editor, :parent => :catalog_editor, :class => User do |record|    
  record.role_objects {|role|  [role.association(:role_content_editor)]}
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
  f.name "Образцы"
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


Factory.sequence :firm_seq do |n|
   "ООО Рога и копыта, клон #{n}"
  end
  

Factory.define :firm do |f|
  f.name {Factory.next(:firm_seq)}
  f.short_name "Рога и копыта"
end

