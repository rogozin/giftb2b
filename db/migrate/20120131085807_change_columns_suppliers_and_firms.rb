#encoding:utf-8;
class ChangeColumnsSuppliersAndFirms < ActiveRecord::Migration
  def up
    say "columns magic"
    remove_column :firms, :is_supplier
    add_column :firms, :supplier_id, :integer    
    say "renaming users that have same names" 
    User.where(:username => Supplier.all.map(&:permalink)).each do |user|
      user.update_attributes :username => user.username + "_1"
    end    

    say "create Role 'lk_supplier'"    
    lk_sup_role = Role.create(:name => "lk_supplier", :description => "Личный кабинет поставщика", :group => 6)    
    lk_news_role = Role.find_by_name("lk_news")
    say "create users from suppliers"
    Supplier.all.each do |sup|
      puts "--#{sup.name}" 
      supplier_role = Role.where(:name => sup.name).first
      pass = User.friendly_pass
      email = "info@#{sup.permalink}.ru"
      puts "--creating firm"
      firm = Firm.create({:name => sup.name, :supplier_id => sup.id, :addr_f => RedCloth.new(sup.address).to_html, 
                          :description => RedCloth.new(sup.terms).to_html, :email => email, :phone => "+7(495)"}, :as => :admin)
      puts "creating user"
      u = User.new({:username => sup.permalink, :password=>pass, :password_confirmation => pass, :email => email, 
                    :company_name => sup.name, :city => "Москва",  :phone => "+7(495)", :active => true, :fio => sup.name}, :as => :admin)
      u.firm = firm
      u.role_objects = [lk_sup_role, supplier_role, lk_news_role]
      if u.save
        puts "============================================  ====================="
        puts "Поставщик: #{sup.name}"
        puts "Логин: #{u.username}"
        puts "Пароль: #{pass}\n"      
      else 
        puts u.errors.full_messages
      end
    end
    
  end

  def down
#    remove_column :firms, :supplier_id
#    add_column :firms, :is_supplier, :boolean
  end
end
