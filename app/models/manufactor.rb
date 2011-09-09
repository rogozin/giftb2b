#encoding: utf-8;
class Manufactor < ActiveRecord::Base
  has_many :products
  scope :active, where("name != 'no_name' and exists (select null from products p where p.manufactor_id = manufactors.id and p.active=1)").order("name")
  
  def self.cached_active_manufactors
    Rails.cache.fetch('active_manufactors', :expires_in => 24.hours) { active.all }
  end
end

