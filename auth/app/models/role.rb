#encoding: utf-8;
class Role < ActiveRecord::Base
  validates_uniqueness_of :name, :allow_nil => false, :allow_blank => false
  validates_presence_of :name
  acts_as_authorization_role :subject_class_name => 'User', :join_table_name => :roles_users
  
  def self.group_names
    ["Администрирование", "CRM",  "Рекламное агентство", "Конечный клиент", "Интернет-магазин", "Поставщик", "Объект", "Прочее"]
  end
end
