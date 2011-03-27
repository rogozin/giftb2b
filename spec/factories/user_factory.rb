Factory.define :admin, :class => User do |record|    
  record.username "administrator"
  record.email "admin@whatever.com"
  record.password "admin"
  record.password_confirmation {|p| p.password }
  record.active true
  record.role_objects {|role|  [role.association(:role_admin)]}
end

Factory.define :firm_manager, :class => User do |record|    
  record.username "firm_manager"
  record.email "firm_manager@whatever.com"
  record.password "firm_manager"
  record.password_confirmation {|p| p.password }
  record.active true
  record.role_objects {|role|  [role.association(:role_firm_manager)]}
end

Factory.define :user, :class => User do |record|    
  record.username "user"
  record.email "user@whatever.com"
  record.password "user"
  record.password_confirmation {|p| p.password }
  record.active true
  record.role_objects {|role|  [role.association(:role_user)]}
end

Factory.define :role_admin, :class => Role do |f|
  f.name "Администратор"
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

