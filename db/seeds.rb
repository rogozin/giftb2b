# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


    #Role.create(:name => "Администратор", :group => 0)
    Role.create(:name => "Менеджер продаж", :group => 0)
    Role.create(:name => "Редактор каталга", :group => 0)
    Role.create(:name => "Редактор контента", :group => 0)
    Role.create(:name => "Учет образцов", :group => 2)
    Role.create(:name => "Пользователь", :group => 1)
    Role.create(:name => "Менеджер фирмы", :group => 2)
    Role.create(:name => "Пользователь фирмы", :group => 2)
    
    #admin = User.new(:username => "admin", :password => "admin", :password_confirmation => "admin",:active => true)
    #admin.save(false)
    #admin.has_role! "Администратор"

