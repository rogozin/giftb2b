#encoding: utf-8;
class Banner < ActiveRecord::Base
  belongs_to :firm
  validates :firm_id, :presence => true
  scope :active, where(:active => true)
  after_save :clear_cahce
  
  def self.types
    [["HTML",0],["Image", 1]]
  end
  
  def self.cached_active_banners
    Rails.cache.fetch('active_banners') {  active.all }
    
  end
  
  def type
    Banner.types[type_id].first
  end
  
  private 
  
  def clear_cahce
   Rails.cache.delete('active_banners')
  end
end
