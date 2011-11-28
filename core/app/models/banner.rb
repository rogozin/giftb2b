#encoding: utf-8;
class Banner < ActiveRecord::Base
  belongs_to :firm
  validates :firm_id, :presence => true
  scope :active, lambda {|pos|  where(:site => Settings.site_id, :active => true, :position => pos) }
  after_save :clear_cache
  
  def self.types
    [["HTML",0],["Image", 1]]
  end
  
  def self.cached_active_banners(position)
    Rails.cache.fetch("site/#{Settings.site_id}/active_banners/#{position}") {  active(position).all }    
    
  end
  
  def type
    Banner.types[type_id].first
  end
  
  def show_on_page?(page = "")
    pages_list = [] 
    pages_list = pages.split(";").map(&:strip) if pages
    pages.blank? || (pages_list.delete("/") == page) || pages_list.any?{|x| page.match(x) }
  end
  
  private 
  
  def del_cache(position, site_no)
    Rails.cache.delete("site/#{Settings.site_id}/active_banners/#{position}")        
  end
  
  def clear_cache
     del_cache(position, site)
     del_cache(position_was, site) if position_changed?
     del_cache(position, site_was) if site_changed?
  end
end
