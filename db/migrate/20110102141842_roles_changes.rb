class RolesChanges < ActiveRecord::Migration
  def self.up
    Role.update_all("name='Менеджер продаж'", "name='Менеджер'")
    Role.update_all("name='Редактор каталога'", "name='Редактор'")    
    
    Role.create({:name => "Редактор контента", :group => 0})
    Role.create({:name => "Менеджер фирмы", :group => 2})    
    Role.create({:name => "Пользователь фирмы", :group => 2})        
  end

  def self.down
  end
end
