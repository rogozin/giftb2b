#encoding: utf-8;
class User < ActiveRecord::Base
  has_many :lk_orders
  acts_as_authentic
  acts_as_authorization_subject :role_class_name => 'Role'
  belongs_to :firm
  belongs_to :supplier
  validates :username, :exclusion => { :in => %w(admin superuser) }
  validates :appoint, :length => {:maximum => 100}
  validates :skype, :length => {:maximum => 25}
  validates :cellphone, :length => {:maximum => 25}
  validates :icq, :length => {:maximum => 25},  :numericality => {:allow_blank => true}
  validates_presence_of :company_name, :city, :phone, :fio, :on => :create

  
  
  def is_admin?
    Rails.cache.fetch("#{cache_key}.is_admin?", :expires_in=>60) {has_role? 'Администратор'}
  end
  
  def is_lk_user?
     Rails.cache.fetch("#{cache_key}.is_lk_user?", :expires_in=>60) {role_objects.exists?(["roles.group>0"])}
  end
  
  def is_admin_user?
     Rails.cache.fetch("#{cache_key}.is_admin_user?", :expires_in=>60) {role_objects.exists?(["roles.group=0"])}
  end
  
  def is_simple_user?
     Rails.cache.fetch("#{cache_key}.is_simple_user?", :expires_in=>60) {role_objects.exists?(["roles.group=1"])}
  end
  
  def is_firm_user?
     Rails.cache.fetch("#{cache_key}.is_firm_user?", :expires_in=>60) {role_objects.exists?(["roles.group=2"])}
  end
  
  def is_firm_manager?
    Rails.cache.fetch("#{cache_key}.is_firm_manager?", :expires_in=>60) { has_role?("Менеджер фирмы")}    
  end
  
  def is_supplier?
    Rails.cache.fetch("#{cache_key}.is_supplier?", :expires_in=>60) { has_role?("Поставщик")}    
  end
  
  def activate!
    self.update_attribute :active, true
  end
    
  def self.friendly_pass
      fr_chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
        newpass = ""
        1.upto(6) { |i| newpass << fr_chars[rand(fr_chars.size-1)] }
        newpass
   end
   
  
  def username_from_email
    username =  email.split("@").first
    username = username.ljust(3,'abc')
    if  User.exists?(:username => username)
      username = username + "_1"
      while User.exists?(:username => username)
        username.succ!
      end        
    end      
    username
  end 
   
 
 
 def self.notify_admins(user)
   User.joins(:role_objects).where("roles.name='Администратор'").each do |admin|
     AdminMailer.new_user_registered(user, admin).deliver
   end
 end  
    
end
